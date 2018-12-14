using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WCFConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            ServiceReference1.Service1Client service1Client = new ServiceReference1.Service1Client("BasicHttpBinding_IService1");
            service1Client.Endpoint.Behaviors.Add(new InspectorBehavior());
            var res = service1Client.GetData(4);
            Console.WriteLine("Pulled from WCF");
            Console.WriteLine(res);
            Console.ReadLine();
        }
    }
}
