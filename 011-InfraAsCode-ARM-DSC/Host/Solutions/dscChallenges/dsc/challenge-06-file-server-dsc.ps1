Configuration Create-File-Shares {

    Import-DscResource -Name MSFT_xSmbShare

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
            DestinationPath = 'D:\Folder3'
            Type = 'Directory'
            Ensure = 'Present'
        }

        # Use imported "xSmbShare" DSC resource to create 3 file shares
        # Each share creation depends on its respective folder being created above
        xSmbShare CreateShare1
        {
            Ensure = "Present" 
            Name   = "Share1"
            Path = "C:\Folder1"  
            Description = "This is the share based on folder 1!"
            DependsOn = "[File]CreateFolder1"
        }
        
        xSmbShare CreateShare2
        {
            Ensure = "Present" 
            Name   = "Share2"
            Path = "C:\Folder2"  
            Description = "This is the share based on folder 2!"
            DependsOn = "[File]CreateFolder2"
        } 

        xSmbShare CreateShare3
        {
            Ensure = "Present" 
            Name   = "Share3"
            Path = "D:\Folder3"  
            Description = "This is the share based on folder 3!"
            DependsOn = "[File]CreateFolder3"
        } 
    }
}