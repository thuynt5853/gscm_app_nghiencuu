using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using WEB.Service.Models.VanBan;

namespace WEB.Service.Controllers.Utils
{
    public class MoKhoaTongDatUtils
    {
        public static string moKhoaTongDat(decimal TongDatId, decimal DuongSuId)
        {
            MoKhoaTongDatDTO dto = new MoKhoaTongDatDTO() { TongDatId = TongDatId, DuongSuId = DuongSuId };
            return moKhoaTongDat(dto);
        }

        private static string moKhoaTongDat(MoKhoaTongDatDTO body)
        {
            Task<string> task = Task.Run<string>(async () => await GetResponseString(body, DataUtils.END_POINT_VOFFICE_UNLOCK));
            return task.Result;
        }

        private static string wrapperResult(object body, String url)
        {
            Task<string> task = Task.Run<string>(async () => await GetResponseString(body, url));
            return task.Result;
        }

        private async static Task<string> GetResponseString(object body, String url)
        {
            var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            var response = await httpClient.PostAsJsonAsync(url, body);
            var contents = await response.Content.ReadAsStringAsync();
            return contents;
        }
    }
}