using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.ServiceModel.Dispatcher;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Xml;
using System.IO;

namespace WCFConsoleApp
{
    public class MyMessageInspector : IClientMessageInspector
    {
        void IClientMessageInspector.AfterReceiveReply(ref Message reply, object correlationState)
        {
            //throw new NotImplementedException();
        }

        object IClientMessageInspector.BeforeSendRequest(ref Message request, IClientChannel channel)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (XmlWriter xmlWriter = XmlWriter.Create(ms))
                {
                    request.WriteMessage(xmlWriter);

                    using (StreamReader sr = new StreamReader(ms))
                    {
                        var res = sr.ReadToEnd();
                        Console.WriteLine(res);
                    }
                }
            }
            //check the request.

            return null;
        }
    }

}
