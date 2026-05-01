import os
import re
import json

def categorize_file(filepath):
    """
    Categorizes a markdown file based on keywords in content and frontmatter.
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Simple keyword matching for categorization
        equipment_map = {
            r'NCR|6634|6622': 'NCR ATM',
            r'Diebold|Opteva': 'Diebold ATM',
            r'Hyosung': 'Nautilus Hyosung',
            r'Bavis': 'Bavis Pneumatics',
            r'American Vault|AV3000|AV700': 'American Vault Pneumatics',
            r'Medeco': 'Locking Systems',
            r'March|March Networks': 'March DVR',
            r'Dahua': 'Dahua DVR',
            r'La Gard|39E|700': 'La Gard Locks',
            r'Epson|TM-U375': 'Epson Validator',
            r'JetSort|2000': 'JetSort Coin Sorter',
            r'JetScan|IFX': 'JetScan Currency Counter',
            r'IH-110': 'Hitachi Currency Counter',
            r'Kisan|K2|K3': 'Kisan Currency Counter',
            r'Audio Authority': 'Audio Systems',
            r'Hamilton|HA-1000|Blower': 'Hamilton Air'
        }

        service_map = {
            r'Manual|Maintenance|Guide|Setup': 'Maintenance',
            r'Error|Troubleshoot|Code|Fix|Jam|Broken': 'Troubleshooting',
            r'Part|Schematic|List': 'Reference',
            r'Install|Mount|Connect|Provision': 'Installation'
        }

        category = "General"
        equipment = "Other"
        
        for pattern, label in equipment_map.items():
            if re.search(pattern, content, re.IGNORECASE):
                equipment = label
                break
        
        for pattern, label in service_map.items():
            if re.search(pattern, content, re.IGNORECASE):
                category = label
                break

        return {
            "file": os.path.basename(filepath),
            "full_path": filepath,
            "equipment": equipment,
            "service_category": category,
            "full_category": f"{equipment} - {category}"
        }
    except Exception as e:
        return {"error": str(e), "file": os.path.basename(filepath)}

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No file or directory provided"}))
        sys.exit(1)
    
    path = sys.argv[1]
    if os.path.isfile(path):
        print(json.dumps([categorize_file(path)]))
    elif os.path.isdir(path):
        results = []
        for root, dirs, files in os.walk(path):
            for file in files:
                if file.endswith('.md'):
                    results.append(categorize_file(os.path.join(root, file)))
        print(json.dumps(results))
    elif path.endswith('.txt'): # Handle file list
        with open(path, 'r') as f:
            files = [line.strip() for line in f if line.strip()]
        results = [categorize_file(f) for f in files]
        print(json.dumps(results))
