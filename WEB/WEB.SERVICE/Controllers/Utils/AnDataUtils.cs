using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using WEB.Service.Models.VanBan;

namespace WEB.Service.Controllers.Utils
{
    public abstract class AnDataUtils
    {
        protected GSTPContext dt;

        protected const int AN_HINH_SU = 1;
        protected const int AN_DAN_SU = 2;
        protected const int AN_HON_NHAN_GIA_DINH = 3;
        protected const int AN_KDTM = 4;
        protected const int AN_LAO_DONG = 5;
        protected const int AN_HANHCHINH = 6;
        protected const int AN_PHA_SAN = 7;

        public AnDataUtils()
        {
            dt = new GSTPContext();
        }
        public AnDataUtils(GSTPContext dtContext)
        {
            dt = dtContext;
        }

        public abstract bool tongDatThuHoi(List<decimal> ids, string reason, string calledBy);

        public abstract bool tongDat(List<decimal> ids);

        protected string wrapperResult(object body, String url)
        {
            Task<string> task = Task.Run<string>(async () => await GetResponseString(body, url));
            return task.Result;
        }

        protected async Task<string> GetResponseString(object body, String url)
        {
            var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            var response = await httpClient.PostAsJsonAsync(url, body);
            var contents = await response.Content.ReadAsStringAsync();
            return contents;
        }
    }
}