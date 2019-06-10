Configuration Create-Folders {

    Node localhost {

        # Use built-in "File" DSC resource to create 3 folders
        File CreateFolder1 {
            DestinationPath = 'C:\Folder1'
            Type = 'Directory'
            Ensure = 'Present'
        }

        File CreateFolder2 {
            DestinationPath = 'C:\Folder2'
            Type = 'Directory'
            Ensure = 'Present'
        }

        File CreateFolder3 {
            DestinationPath = 'C:\Folder3'
            Type = 'Directory'
            Ensure = 'Present'
        }
    }
}