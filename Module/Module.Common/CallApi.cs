using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using DAL.GSTP;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json;
using RestSharp;

namespace Module.Common
{
    public class ApiContentType
    {
        public const string text_plain = "text/plain";
        public const string application_json = "application/json";
        public const string application_x_www_form_urlencoded = "application/x-www-form-urlencoded";
    }
    public class DVCMethod
    {
        public const string authorize = "authorize";
        public const string introspect = "introspect";
        public const string token = "token";
        public const string userinfo = "userinfo";
        public const string revoke = "revoke";
    }
    public class DoiTacHeader
    {
        public DoiTacHeader()
        {

        }
        public DoiTacHeader(string _clientId, string _key)
        {
            this.ClientId = _clientId;
            this.SecretKey = _key;
        }
        public string ClientId { get; set; }
        public string Password { get; set; }
        public string SecretKey { get; set; }
    }

    public class CallApi
    {
        public string ApiUrl { get; set; }
        public CallApi()
        { }
        public CallApi(string _apiurl)
        {
            this.ApiUrl = _apiurl;
        }
        #region utility
        private string getParaUrl(object paraInput)
        {
            if (paraInput != null)
            {
                var props = paraInput.GetType().GetProperties();
                string _paras = "";
                foreach (var p in props)
                {
                    var _val = p.GetValue(paraInput, null);
                    if (_val == null || string.IsNullOrEmpty(_val.ToString()))
                        continue;
                    if (string.IsNullOrEmpty(_paras))
                        _paras = string.Format("?{0}={1}", p.Name, _val);
                    else
                        _paras = _paras + string.Format("&{0}={1}", p.Name, _val);
                }
                return _paras;
            }
            return "";
        }
        private void addHeader(HttpClient client, string apiUrl, string token, DoiTacHeader header, string ContentType)
        {
            client.BaseAddress = new System.Uri(apiUrl);
            client.DefaultRequestHeaders.Accept.Clear();
            if (string.IsNullOrEmpty(ContentType))
                ContentType = "application/json";
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(ContentType));
            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            }
            if (header != null)
            {
                client.DefaultRequestHeaders.Add(nameof(header.ClientId), header.ClientId);
                client.DefaultRequestHeaders.Add(nameof(header.Password), header.Password);
                client.DefaultRequestHeaders.Add(nameof(header.SecretKey), header.SecretKey);
            }
        }
        #endregion
        #region Using HttpClient
        /// <summary>
        /// lay thong tin theo list object
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="ApiAction"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public async Task<List<T>> GetListGSApi<T>(string ApiAction, object paramInput = null, string token = null, DoiTacHeader header = null, string ContentType = null)
        {
            string apiUrl = this.ApiUrl + ApiAction;
            var dataret = new List<T>();
            apiUrl = apiUrl + getParaUrl(paramInput);
            using (HttpClient client = new HttpClient())
            {
                addHeader(client, apiUrl, token, header, ContentType);
                HttpResponseMessage response;

                response = await client.GetAsync(client.BaseAddress);

                if (response.IsSuccessStatusCode)
                {
                    //string json
                    dataret = await response.Content.ReadAsAsync<List<T>>();
                }

            }
            return dataret;
        }
        public async Task<T> GetObjectGSApi<T>(string ApiAction, object paramInput = null, string token = null, DoiTacHeader header = null, string ContentType = null)
        {
            string apiUrl = this.ApiUrl + ApiAction;
            T dataret = default(T);
            apiUrl = apiUrl + getParaUrl(paramInput);
            using (HttpClient client = new HttpClient())
            {
                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                       | SecurityProtocolType.Tls11
                       | SecurityProtocolType.Tls12
                       | SecurityProtocolType.Ssl3;
                addHeader(client, apiUrl, token, header, ContentType);
                HttpResponseMessage response;
                response = await client.GetAsync(client.BaseAddress);

                if (response.IsSuccessStatusCode)
                {
                    dataret = await response.Content.ReadAsAsync<T>();
                }

            }
            return dataret;
        }

        public async Task<List<T>> PostListGSApi<T>(string ApiAction, object paramInput = null, string token = null, DoiTacHeader header = null, string ContentType = null)
        {
            string apiUrl = this.ApiUrl + ApiAction;
            var dataret = new List<T>();
            using (HttpClient client = new HttpClient())
            {
                addHeader(client, apiUrl, token, header, ContentType);
                HttpResponseMessage response;

                response = await client.PostAsJsonAsync(client.BaseAddress, paramInput);

                if (response.IsSuccessStatusCode)
                {
                    //string json
                    dataret = await response.Content.ReadAsAsync<List<T>>();
                }

            }
            return dataret;
        }
        Dictionary<string, TValue> ToDictionary<TValue>(object obj)
        {
            var json = JsonConvert.SerializeObject(obj);
            var dictionary = JsonConvert.DeserializeObject<Dictionary<string, TValue>>(json);
            return dictionary;
        }
        public async Task<T> PostObjectGSApi<T>(string ApiAction, object paramInput = null, string token = null, DoiTacHeader header = null, string ContentType = null)
        {
            string apiUrl = this.ApiUrl + ApiAction;
            T dataret = default(T);
            using (HttpClient client = new HttpClient())
            {
                addHeader(client, apiUrl, token, header, ContentType);


                var response = await client.PostAsJsonAsync(apiUrl, paramInput);

                if (response.IsSuccessStatusCode)
                {
                    dataret = await response.Content.ReadAsAsync<T>();
                }

            }
            return dataret;
        }

        /// <summary>
        /// Ham nay goi api update du lieu, ko can biet thanh cong hay khong
        /// </summary>
        /// <param name="ApiAction"></param>
        /// <param name="paramInput"></param>
        /// <param name="token"></param>
        public async Task PostGSApi(string ApiAction, object paramInput = null, string token = null, DoiTacHeader header = null, string ContentType = null)
        {
            string apiUrl = this.ApiUrl + ApiAction;
            using (HttpClient client = new HttpClient())
            {
                addHeader(client, apiUrl, token, header, ContentType);
                HttpResponseMessage response;
                response = await client.PostAsJsonAsync(client.BaseAddress, paramInput);

                if (response.IsSuccessStatusCode)
                {
                }
            }
        }
        #endregion
        #region Using RestClient
        RestRequest BindRequest(object paramInput, string token = null, Method method=Method.POST)
        {
            var request = new RestRequest(method);
            request.AddHeader("Content-Type", "application/x-www-form-urlencoded");
            if(string.IsNullOrEmpty(token))
            {
                request.AddHeader("Authorization", "Bearer "+token);
            }
            if(paramInput!=null)
            {
                var props = paramInput.GetType().GetProperties();
                foreach (var p in props)
                {
                    var _val = p.GetValue(paramInput, null);
                    if (_val == null || string.IsNullOrEmpty(_val.ToString()))
                        continue;
                    request.AddParameter(p.Name, _val);                    
                }
                
            }
            
            return request;
        }
        public T PostObjectRestApi<T>(string ApiAction, object paramInput = null, string token = null)
        {
            string apiUrl = this.ApiUrl + ApiAction;
            T dataret = default(T);

            var client = new RestClient(apiUrl);
            client.Timeout = -1;
            IRestResponse response = client.Execute(BindRequest(paramInput, token));
            if(response.IsSuccessful)
            {
                dataret=response.Content.toEntity<T>();
            }
            return dataret;
        }
        public T GetObjectRestApi<T>(string apiUrl, object paramInput = null, string token = null)
        {
            T dataret = default(T);

            var client = new RestClient(apiUrl);
            client.Timeout = -1;
            IRestResponse response = client.Execute(BindRequest(paramInput, token,Method.GET));
            if (response.IsSuccessful)
            {
                dataret = response.Content.toEntity<T>();
            }
            return dataret;
        }
        #endregion
    }

}