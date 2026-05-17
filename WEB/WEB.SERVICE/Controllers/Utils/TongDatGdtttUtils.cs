using BL.GSTP.BANGSETGET;
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
    public class TongDatGdtttUtils
    {
        private static GSTPContext context = new GSTPContext();

        public static TongDatGdtttDTO toDTO(TONGDAT_GDKT gdkt, List<TONGDAT_GDKT_NOINHAN> dsNoiNhan)
        {
            TongDatGdtttDTO tongDatGdtttDTO = new TongDatGdtttDTO();
            tongDatGdtttDTO.Id = gdkt.ID;
            tongDatGdtttDTO.Tenvanban = gdkt.TENVANBAN;
            tongDatGdtttDTO.SoVb = gdkt.SOVB;
            tongDatGdtttDTO.NgayVb = gdkt.NGAYVB.GetValueOrDefault(DateTime.Now);
            tongDatGdtttDTO.Donviphathanh = gdkt.DONVIPHATHANH;
            tongDatGdtttDTO.ToaAnId = gdkt.TOAANID.GetValueOrDefault(0);
            tongDatGdtttDTO.DoiTuong = dsNoiNhan.Select(noiNhan => toDTO(noiNhan)).ToList();
            return tongDatGdtttDTO;
        }

        public static DoiTuongGdtttDTO toDTO(TONGDAT_GDKT_NOINHAN noiNhan)
        {
            DoiTuongGdtttDTO doiTuongGdtttDTO = new DoiTuongGdtttDTO();
            doiTuongGdtttDTO.NoinhanId = noiNhan.NOINHAN_ID.GetValueOrDefault(0);
            doiTuongGdtttDTO.Noinhan = noiNhan.NOINHAN;
            doiTuongGdtttDTO.Tucachtotung = noiNhan.TUCACHTOTUNG;
            doiTuongGdtttDTO.Diachi = noiNhan.DIACHI;
            doiTuongGdtttDTO.Hinhthucgui = noiNhan.HINHTHUCGUI.GetValueOrDefault(0);
            doiTuongGdtttDTO.Phathanhlai_id = noiNhan.PHATHANHLAI_ID.GetValueOrDefault(0);
            return doiTuongGdtttDTO;
        }

        public static string tongDatGdtttt(TONGDAT_GDKT gdkt, List<TONGDAT_GDKT_NOINHAN> dsNoiNhan)
        {
            TongDatGdtttDTO body = toDTO(gdkt, dsNoiNhan);
            Task<string> task = Task.Run<string>(async () => await GetResponseString(body, DataUtils.END_POINT_VOFFICE_GDTTT));
            return task.Result;
        }

        public static string tongDatGdtttt(TongDatGdtttDTO body)
        {
            Task<string> task = Task.Run<string>(async () => await GetResponseString(body, DataUtils.END_POINT_VOFFICE_GDTTT));
            return task.Result;
        }

        private static string thuHoiTongDatGdtttt(object body)
        {
            Task<string> task = Task.Run<string>(async () => await GetResponseString(body, DataUtils.END_POINT_VOFFICE_GDTTT_REALLOCATE));
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