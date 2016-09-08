// The tests we used were:

"Modality-toolkit".include; // and reboot interpreter


// this is the class method where the difference occurs:
MKtlDesc.loadDescs.size; // osx: finds 69 desc files - win: 55 - 15 are in subfolders

// do the lookup by hand with pathMatch
(MKtlDesc.descFolders[0] +/+ "*.desc.scd").pathMatch.size; // osx: 53 - win: 55

// look into subfolders - not working
(MKtlDesc.descFolders[0] +/+ "*" +/+ "*.desc.scd").pathMatch.size; // osx: 17 - win: 0

// look for other file type in subfolders - not working
(MKtlDesc.descFolders[0] +/+ "*" +/+ "*.parentDesc.scd").pathMatch.size; // osx: 4  - win: 0


// looking at the paths, it all seems ok AFAICT

MKtlDesc.descFolders[0].postcs;
#-> C:\Users\gilFuser\AppData\Local\SuperCollider\downloaded-quarks\Modality-toolkit\Modality\MKtlDescriptions

(MKtlDesc.descFolders[0] +/+ "*").postcs;
#-> C:\Users\gilFuser\AppData\Local\SuperCollider\downloaded-quarks\Modality-toolkit\Modality\MKtlDescriptions\*

(MKtlDesc.descFolders[0] +/+ "*" +/+ "*.desc.scd").postcs;
#-> C:\Users\gilFuser\AppData\Local\SuperCollider\downloaded-quarks\Modality-toolkit\Modality\MKtlDescriptions\*\*.desc.scd