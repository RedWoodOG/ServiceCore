import json
import os
import re

def inject_metadata(results_path):
    """
    Reads categorization results and injects them into the markdown files.
    """
    with open(results_path, 'r') as f:
        results = json.load(f)

    for entry in results:
        filepath = entry.get('full_path')
        if not filepath or not os.path.exists(filepath):
            continue

        equipment = entry.get('equipment')
        service = entry.get('service_category')
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()

            # Check for existing YAML frontmatter
            if content.startswith('---'):
                parts = re.split(r'---\s*\n', content, maxsplit=2)
                if len(parts) >= 3:
                    frontmatter = parts[1]
                    body = parts[2]
                    
                    # Update or add fields
                    if 'equipment_type:' in frontmatter:
                        frontmatter = re.sub(r'equipment_type:.*', f'equipment_type: "{equipment}"', frontmatter)
                    else:
                        frontmatter += f'equipment_type: "{equipment}"\n'
                        
                    if 'service_category:' in frontmatter:
                        frontmatter = re.sub(r'service_category:.*', f'service_category: "{service}"', frontmatter)
                    else:
                        frontmatter += f'service_category: "{service}"\n'
                        
                    # Standardize tags/categories for consistency
                    if 'category:' in frontmatter:
                        frontmatter = re.sub(r'category:.*', f'category: "{equipment}"', frontmatter)
                    
                    new_content = f"---\n{frontmatter.strip()}\n---\n{body}"
                else:
                    new_content = content # Failed to parse properly
            else:
                # No frontmatter, create it
                title = os.path.basename(filepath).replace('.md', '').replace('_', ' ').title()
                header = f"---\ntitle: \"{title}\"\nequipment_type: \"{equipment}\"\nservice_category: \"{service}\"\ncategory: \"{equipment}\"\nstatus: \"active\"\nversion: \"1.0.0\"\n---\n\n"
                new_content = header + content

            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
                
            print(f"Injected metadata into {os.path.basename(filepath)}")
            
        except Exception as e:
            print(f"Error processing {filepath}: {e}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python inject_metadata.py <results_json_path>")
        sys.exit(1)
    
    inject_metadata(sys.argv[1])
