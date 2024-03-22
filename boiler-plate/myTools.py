import re

class Incar:
    """
    Class providing tools for manipulating properties inside INCAR file

    """
    def __init__(self,text:str=None, fileName:str = None):
        self.lines=[]
        if text is not None:
            self.lines = text.splitlines(keepends=True)
        elif fileName is not None:
            with open(fileName, 'r') as file:
                self.lines = file.readlines()
    

    def set(self,key:str,value:str,comment:str=None):
        """
        Change the value of the key provided.
        If key does not exist it adds in the end
        """
        pattern=r"\b"+key+r"\b\s*=\s*([^#\n]+?)(?:\s*#\s*(.*))?$"
        for i,line in enumerate(self.lines):
            match = re.search(pattern, line)
            if match:
                comment = match.group(2)
                self.lines[i] = f"    {key:<10} = {value:<10} # {comment} \n"
                return
        print(f"Key {key} not found, adding now...")
        self.lines.append(f"    {key:<10} = {value:<10} # {comment} \n")
    
    def comment(self,key):
        """
        Comment out the key prop
        """
        pattern=r"\b"+key+r"\b\s*=\s*([^#\n]+?)(?:\s*#\s*(.*))?$"
        for i,line in enumerate(self.lines):
            match = re.search(pattern, line)
            if match:
                value = match.group(1)
                comment = match.group(2)
                self.lines[i] = f"    # {key:<10} = {value:<10} # {comment} \n"
                return
        print(f"Key {key} not found in INCAR lines.")

    def uncomment(self,key):
        """
        Comment out the key prop
        """
        pattern=r"\b"+key+r"\b\s*=\s*([^#\n]+?)(?:\s*#\s*(.*))?$"
        for i,line in enumerate(self.lines):
            match = re.search(pattern, line)
            if match:
                value = match.group(1)
                comment = match.group(2)
                self.lines[i] = f"    {key:<10} = {value:<10} # {comment} \n"
                return
        print(f"Key {key} not found in INCAR lines.")


    def write_file(self,fileName:str):
        """
        Write this object in the INCAR file
        """
        with open(fileName,"w+") as file:
            file.writelines(self.lines)
    

