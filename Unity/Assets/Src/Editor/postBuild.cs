using UnityEngine;
using UnityEditor;
using System.Collections;
#if UNITY_IOS
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
#endif
using System.IO;
namespace NativeMusicAcessHelp{


	public class postBuild {
#if UNITY_IOS
		[PostProcessBuild]
		public static void OnPostBuild(BuildTarget buildTarget, string path)
		{
			string plistPath = path + "/Info.plist";
			PlistDocument plist = new PlistDocument();  
			plist.ReadFromString(File.ReadAllText(plistPath));  
			PlistElementDict rootDict = plist.root;  
			rootDict.SetString ("NSAppleMusicUsageDescription", NativeMusicAcessHelp.Common.iOSMusicUsageDescription);
			File.WriteAllText(plistPath, plist.WriteToString());  
		}
#endif
    }
}