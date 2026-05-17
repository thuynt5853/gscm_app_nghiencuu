using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Models;
using WEB.Service.Models.VanBan;
using Module.Common;
using System.Data;
using WEB.Service.Controllers.Utils;
using BL.GSTP.GDTTT;
using BL.GSTP.BANGSETGET;
using Newtonsoft.Json;

namespace WEB.Service.Controllers
{
    public class WS_ThongBaoACV : ApiController
    {

        // khai báo danh sách sequence của các bảng
        private const string VT_THONGBAOVNEID_SEQ = "VT_THONGBAOVNEID_SEQ";
        private GSTPContext context = new GSTPContext();
        //private VT_VANTHU_DEN_BL vanThuDenBL = new VT_VANTHU_DEN_BL();
        //private VT_CHUYEN_NHAN_BL chuyenNhanBL = new VT_CHUYEN_NHAN_BL();

        /// <summary>
        /// Hàm kiểm tra token hợp lệ
        /// </summary>
        /// <param name="token">Token kiểm tra</param>
        /// <returns>Trả về true nếu token hợp lệ, false nếu không hợp lệ</returns>
        private bool isAccesable(string token)
        {
            DM_TOKEN_KEY oTokenKey = context.DM_TOKEN_KEY
                .Where(x => x.TOKEN_KEY.ToLower() == token.ToLower())
                .FirstOrDefault<DM_TOKEN_KEY>();
            if (oTokenKey != null)
                return oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            return false;
        }

        /// <summary>
        /// Hàm thực hiện kiểm tra token 
        /// </summary>
        /// <param name="token">Token cần kiểm tra</param>
        /// <returns>Kết quả kiểm tra token</returns>
        private MessageResult checkToken(string token)
        {
            if (!isAccesable(token))
            {
                MessageResult result = new MessageResult();
                result.Status = "01";
                result.Message = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return result;
            }
            return null;
        }

        /// <summary>
        /// Hàm lấy thông tin token từ header
        /// </summary>
        /// <returns>Trả lại giá trị token từ header</returns>
        private string getTokenInHeader()
        {
            var re = Request;
            var headers = re.Headers;
            if (headers.Contains("token"))
            {
                string token = headers.GetValues("token").First();
                return token;
            }
            return null;
        }

        public class ThongBaoVneID
        {
            public string requestId { get; set; }
            public string notiTypeCode { get; set; }
            public string notiNumber { get; set; }
            public int isView { get; set; }
            public DateTime viewDate { get; set; }
        }

        /// <summary>
        /// API Nhận thông tin văn bản đến - Sơ thẩm, phúc thẩm
        /// </summary>
        /// <param name="body">Thông tin văn bản đến</param>
        /// <returns>Kết quả tiếp nhận thông tin văn bản đến</returns>
        [HttpPost]
        [Route("api/DichVuTraTrangThaiDaXemThongBao")]
        public object DichVuTraTrangThaiDaXemThongBao([FromBody]ThongBaoVneID body)
        {
            LOG_API log = new LOG_API();
            var json = "";
            string token = getTokenInHeader();
            var resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }
            MessageResult oMsg = new MessageResult();
            if (body != null)
            {
                json = JsonConvert.SerializeObject(body, Formatting.Indented);
                if (!string.IsNullOrEmpty(body.notiNumber))
                {
                    try
                    {
                        string notiNumberCode = "";
                        string notiNumberId = "";
                        try
                        {
                            var data = body.notiNumber.Split('.');
                            if (data.Length < 2)
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Số thông báo đầu vào không đúng định dạng!";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", oMsg.Message, json);

                                return oMsg;
                            }
                            notiNumberCode = data[0];
                            notiNumberId = data[1];
                        }
                        catch (Exception ex)
                        {
                            oMsg.Status = "0";
                            oMsg.Message = ex.Message.ToString();

                            //log
                            log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", oMsg.Message, json);

                            return oMsg;
                        }
                        decimal notiNumber = decimal.Parse(notiNumberId);
                        if (notiNumberCode == "DS")
                        {
                            ADS_TONGDAT_DOITUONG obj = context.ADS_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<ADS_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "DS", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "DS - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        else if (notiNumberCode == "HC")
                        {
                            AHC_TONGDAT_DOITUONG obj = context.AHC_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<AHC_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "HC", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "HC - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        else if (notiNumberCode == "HNGD")
                        {
                            AHN_TONGDAT_DOITUONG obj = context.AHN_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<AHN_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "HN", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "HN - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        else if (notiNumberCode == "HS")
                        {
                            AHS_TONGDAT_DOITUONG obj = context.AHS_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<AHS_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "HS", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "HS - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        else if (notiNumberCode == "KDTM")
                        {
                            AKT_TONGDAT_DOITUONG obj = context.AKT_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<AKT_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "KDTM", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "KDTM - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        else if (notiNumberCode == "LD")
                        {
                            ALD_TONGDAT_DOITUONG obj = context.ALD_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<ALD_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "LD", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "LD - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        else if (notiNumberCode == "PS")
                        {
                            APS_TONGDAT_DOITUONG obj = context.APS_TONGDAT_DOITUONG.Where(x => x.ID == notiNumber).FirstOrDefault<APS_TONGDAT_DOITUONG>();
                            if (obj != null && obj.VNEID_VIEWDATE == null)
                            {
                                obj.VNEID_VIEWDATE = body.viewDate;
                                obj.VNEID_ISVIEW = body.isView;
                                obj.VNEID_SYSDATE = DateTime.Now;
                                context.SaveChanges();

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "PS", json);
                            }
                            else
                            {
                                oMsg.Status = "0";
                                oMsg.Message = "Không tìm thấy Số thông báo trên hệ thống";

                                //log
                                log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", "PS - " + oMsg.Message, json);

                                return oMsg;
                            }
                            //---------------
                            oMsg.Status = "1";
                            oMsg.Message = "Thành công";
                            return oMsg;
                        }
                        oMsg.Status = "0";
                        oMsg.Message = "Không tìm thấy Số thông báo tương ứng! Vui lòng kiểm tra lại!";

                        //log
                        log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", oMsg.Message, json);

                        return oMsg;
                    }
                    catch (Exception ex)
                    {
                        oMsg.Status = "0";
                        oMsg.Message = ex.Message.ToString();

                        //log
                        log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", oMsg.Message, json);

                        return oMsg;
                    }
                }
                else
                {
                    oMsg.Status = "0";
                    oMsg.Message = "Trường 'notiNumber' không được để trống!";
                    //log
                    log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", oMsg.Message, json);
                    
                    return oMsg;
                }
            }
            oMsg.Status = "0";
            oMsg.Message = "Không thấy Request Body!";

            //log
            log.InsertLog("api/DichVuTraTrangThaiDaXemThongBao", oMsg.Message, json);

            return oMsg;
        }

    }
}