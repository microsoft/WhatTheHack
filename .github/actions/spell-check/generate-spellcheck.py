import sys
import os
import yaml
import json

CUSTOM_WORD_LIST_FILENAME = '.wordlist.txt'

def find_wordlist_files(path):
    wordlist_paths = []
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(CUSTOM_WORD_LIST_FILENAME):
                wordlist_paths.append(os.path.join(root, file))
    return wordlist_paths
    
if __name__ == '__main__':
    spell_check_yaml_path = sys.argv[1]
    markdown_base_path = sys.argv[2]
    changed_files_tmp = sys.argv[3:]
    # the changed files come in as a list with a single element, each of which is space-separated in the first element
    # therefore, we need to split them
    changed_files = changed_files_tmp[0].split(' ')

    spell_check_yaml = None

    with open(spell_check_yaml_path, 'r') as read_file:
        spell_check_yaml = yaml.load(read_file, Loader=yaml.FullLoader)

    wordlist_paths = find_wordlist_files(markdown_base_path)

    # Add any custom wordlists defined to the spellcheck config
    spell_check_yaml['matrix'][0]['dictionary']['wordlists'].extend(wordlist_paths)

    # Set the list of files to check
    spell_check_yaml['matrix'][0]['sources'] = changed_files

    with open(spell_check_yaml_path + ".tmp", 'w') as write_file:
        #yaml.dump doesn't work in Python >3, so we dump to JSON instead & convert using yq in the outer script
        #yaml.dump(write_file, spell_check_yaml, Dumper=yaml.Dumper)
        json.dump(spell_check_yaml, write_file, indent=4)