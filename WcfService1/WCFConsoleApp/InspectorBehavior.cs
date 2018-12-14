using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using System.ServiceModel.Channels;

namespace WCFConsoleApp
{
    public class InspectorBehavior : IEndpointBehavior
    {


        void IEndpointBehavior.AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
            //throw new NotImplementedException();
        }

        public void ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
            //for testing, we can use the message inspector.
            //clientRuntime.MessageInspectors.Add(new MyMessageInspector());
        }

        void IEndpointBehavior.ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            //throw new NotImplementedException();
        }

        void IEndpointBehavior.Validate(ServiceEndpoint endpoint)
        {
            //throw new NotImplementedException();
        }
    }
}
