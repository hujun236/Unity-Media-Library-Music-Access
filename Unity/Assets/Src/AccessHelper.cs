using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_IOS
using System.Runtime.InteropServices;
#endif
namespace NativeMusicAcessHelp
{
	public class AccessHelper : MonoBehaviour
		{
	#if UNITY_IOS

		[DllImport("__Internal")]
		private static extern string GetAllMusicReturnJson();
		[DllImport("__Internal")]
		private static extern void GetMusicPathByID(string ID );
	#endif


			private static bool Inited = false;
			private static GameObject obj = null;
			private static void Init()
			{
				if (Inited)
					return;

				obj = new GameObject(Common.NativeMsgReciveObjName);
				GameObject.DontDestroyOnLoad(obj);
				obj.AddComponent<NativeMusicAcessHelp.AccessHelper>();
				Inited = true;
			}

			public delegate void GetFilePathResultDelegate(string result);
			private static GetFilePathResultDelegate _delegate = null;

			public static void OnGetPath(GetFilePathResultDelegate d)
			{
				_delegate = d;
			}
			public static string GetAllMusicAndReturnJson()
			{
#if UNITY_IOS && !UNITY_EDITOR
				return GetAllMusicReturnJson();
#endif
#if UNITY_ANDROID && !UNITY_EDITOR
            AndroidJavaClass cls = new AndroidJavaClass("com.tina.nativemusiceaccess.Manager");
            return cls.CallStatic<string>("GetAllMusicInfo");
#endif
            return "[]";
			}

			public static void GetFilePathByID(string id)
			{
				Init();

#if UNITY_IOS && !UNITY_EDITOR
				GetMusicPathByID(id);
#endif

#if UNITY_ANDROID && !UNITY_EDITOR
                if (_delegate != null)
                    _delegate.Invoke("{\"id\":\"" + id + "\",\"path\":\"" + id + "\"}");
#endif
        }


        public void OnGetFilePath(string resultJson)
			{
				if (_delegate != null)
					_delegate.Invoke(resultJson);
			}
		}
}