using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace NativeMusicAcessHelp{
	public class Example : MonoBehaviour {

		
		void Start () {
			 {

                //step 1： get all music array in json format，like：
                /*
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
                */
                string resultJson = NativeMusicAcessHelp.AccessHelper.GetAllMusicAndReturnJson();
                Debug.LogError("all music data=" + resultJson);





                //step 2：set the filepath query result delegate
                NativeMusicAcessHelp.AccessHelper.OnGetPath((string result) => {
                    //step 4 getthe filepath info like：   {"id":"music id1", "path":"musicFilePath"}
                    Debug.LogError("get music path result" + result);
                });


            //step 3: query filepath by id
            NativeMusicAcessHelp.AccessHelper.GetFilePathByID("music id1");

        }	
		}
		
		
	}
}