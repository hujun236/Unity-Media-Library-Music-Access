# Unity-Media-Library-Music-Access
access the music list and get the real file path on android and ios devices

# useage
## step 1： get all music array in json format  
string resultJson = NativeMusicAcessHelp.AccessHelper.GetAllMusicAndReturnJson();  

the resultJson likes:  
```json
[
  {
	"id" : "music id1",
	"title" : "music title 1",
	"artist" : "artist 1"
  },
  {
	"id" : "music id2",
	"title" : "music title 2",
	"artist" : "artist 2"
  }
]
```

## step 2：set the filepath query result delegate  

```c#
NativeMusicAcessHelp.AccessHelper.OnGetPath((string result) => {
                    // get the filepath info like：   {"id":"music id1", "path":"musicFilePath"}
                    Debug.LogError(" music path result" + result);
                });
```
			
## step 3: query filepath by id
NativeMusicAcessHelp.AccessHelper.GetFilePathByID("music id1");


## step 4:   
modify Common.iOSMusicUsageDescription,it will auto modify the info.plist's NSAppleMusicUsageDescription field after build ios project
