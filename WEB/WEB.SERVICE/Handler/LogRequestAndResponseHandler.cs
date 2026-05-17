using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;

namespace WEB.Service.Handler
{
    public class LogRequestAndResponseHandler : DelegatingHandler
    {
        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request, CancellationToken cancellationToken)
        {
            if (request.Content != null)
            {
                // log request body
                string requestInfo = request.ToString();
                string requestBody = await request.Content.ReadAsStringAsync();
                Trace.WriteLine(
                    DateTime.Now + " -> request = " + Environment.NewLine +
                    requestInfo + Environment.NewLine + 
                    requestBody + Environment.NewLine + 
                    "---");
            }
            // let other handlers process the request
            var result = await base.SendAsync(request, cancellationToken);

            if (result.Content != null)
            {
                // once response body is ready, log it
                var requestInfo = result.ToString();
                var responseBody = await result.Content.ReadAsStringAsync();
                Trace.WriteLine(
                    DateTime.Now + " -> response = " + Environment.NewLine +
                    requestInfo + Environment.NewLine +
                    responseBody + Environment.NewLine + 
                    "---------------------------");
            }

            return result;
        }
    }
}