using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;
using BL.GSTP.TONGDAT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Controllers.Utils;
using WEB.Service.Models;
using WEB.Service.Models.VanBan;
using WEB.Service.Service.Auth;
using WEB.Service.Service;
using System.Data;


namespace WEB.Service.Controllers
{
    public class WS_VanBanDiController : ApiController
    {

        private const int AN_HINH_SU = 1;
        private const int AN_DAN_SU = 2;
        private const int AN_HON_NHAN_GIA_DINH = 3;
        private const int AN_KDTM = 4;
        private const int AN_LAO_DONG = 5;
        private const int AN_HANHCHINH = 6;
        private const int AN_PHA_SAN = 7;

        private GSTPContext context = new GSTPContext();
        private TONGDAT_GDKT_BL tongDatGdktBL = new TONGDAT_GDKT_BL();
        private TONGDAT_HCTP_BL tongDatHctpBL = new TONGDAT_HCTP_BL();

        private bool isAccesable(string token)
        {
            DM_TOKEN_KEY oTokenKey = context.DM_TOKEN_KEY
                .Where(x => x.TOKEN_KEY.ToLower() == token.ToLower())
                .FirstOrDefault<DM_TOKEN_KEY>();
            //oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            //long a = DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
           
            if (oTokenKey != null)
                return oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            return false;
        }

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

        [HttpPost]
        [Route("api/ban-hanh")]
        public MessageResult BanHanh(BanHanhDTO banHanhDTO)
        {
            try
            {
                string token = getTokenInHeader();
                MessageResult resultToken = checkToken(token);
                if (resultToken != null)
                {
                    return resultToken;
                }
                if (banHanhDTO == null) return MessageResult._error("Tham số không hợp lệ");
                long loaiAnId = banHanhDTO.LoaiAnId;
                long loaiTongDat = banHanhDTO.LoaiTongDat;
                List<TTDuongSuDTO> ttDuongSuDTOs = banHanhDTO.TTDuongSuDTOs;
                //ST,PT
                GSTPContext dt = new GSTPContext();
                if (loaiTongDat == 1)
                {
                    if (loaiAnId == 1)
                    {
                        AHS_TONGDAT TONGDAT = context.AHS_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");
                        DAL.GSTP.DM_BIEUMAU bieuMau = context.DM_BIEUMAU.Where(x => x.ID == TONGDAT.BIEUMAUID).First();
                        if (bieuMau == null) return MessageResult._error("Không tìm thấy văn bản");

                        string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);

                        TONGDAT.TRANGTHAI = 2; //đã xử lý
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                AHS_FILE objFile = new AHS_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.AHS_FILE.Add(objFile);
                                TONGDAT.FILEID = objFile.ID;
                            }
                            context.SaveChanges();
                        }

                        List<AHS_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.AHS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (AHS_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = ttDuongSuDTO.SendDate;
                                doiTuong.NGAYPHATHANH_HETHONG = DateTime.Now;

                                //Call API jobshare đẩy sang VNEID với thông báo án phí
                                //set thoi gian time out gọi API 30s sau thời gian đó ghi vào bảng bên JOBSHARE sẽ kiểm tra nếu chưa lưu thì lưu, nếu nưu rồi thì thôi xoa di
                                // Giao diện màn 3.3 QĐ vụ án án Hình sự
                                AHS_TONGDAT td = dt.AHS_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).FirstOrDefault();
                                if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QUYETDINH_ST_AHS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_QD_ST_AHS(1, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // Giao diện màn 3.4 Bản án/ QĐ Sơ thẩm án Hình sự
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_ST_AHS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_BANAN_ST_AHS(1, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // Giao diện màn 4.6 Bản án/ QĐ phúc thẩm án Hình sự
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_PT_AHS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_BANAN_PT_AHS(1, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // Giao diện màn 4.5 QĐ Phúc thẩm án Hình sự
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QUYETDINH_PT_AHS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_QD_PT_AHS(1, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                            }
                        }
                    }
                    else if (loaiAnId == 2)
                    {
                        DAL.GSTP.ADS_TONGDAT TONGDAT = context.ADS_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");
                        DAL.GSTP.DM_BIEUMAU bieuMau = context.DM_BIEUMAU.Where(x => x.ID == TONGDAT.BIEUMAUID).First();
                        if (bieuMau == null) return MessageResult._error("Không tìm thấy văn bản");
                        // VNPT Nguyễn Đăng Huy Hoàng  15:00 05/11/2025
                        // kiểm tra điều kiện không có tên file thì không cập nhật trạng thái tống đạt
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TRANGTHAI = 2; //đã xử lý
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                ADS_FILE objFile = new ADS_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.ADS_FILE.Add(objFile);
                                TONGDAT.FILEID = objFile.ID;
                            }
                            context.SaveChanges();
                        }

                        List<ADS_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.ADS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (ADS_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = doiTuong.NGAYPHATHANH == null ? ttDuongSuDTO.SendDate : doiTuong.NGAYPHATHANH;
                                doiTuong.NGAYPHATHANH_HETHONG = doiTuong.NGAYPHATHANH_HETHONG == null ? DateTime.Now : doiTuong.NGAYPHATHANH_HETHONG;


                                //Call API jobshare đẩy sang VNEID với thông báo án phí
                                //set thoi gian time out gọi API 30s sau thời gian đó ghi vào bảng bên JOBSHARE sẽ kiểm tra nếu chưa lưu thì lưu, nếu nưu rồi thì thôi xoa di
                                //(67: án phí ,381: lệ phí
                                ADS_TONGDAT td = dt.ADS_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).FirstOrDefault();
                                string code;
                                if (td != null && (td.BIEUMAUID == 67 || td.BIEUMAUID == 381))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM thu ly
                                else if(td != null && td.BIEUMAUID == 68)
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM GIAI QUYET DON
                                else if (td != null
                                         && ENUM_PHATHANH_BIEUMAU_DS.IsValid_ADS_ST_GIAI_QUYET_DON(bieuMau.MABM))
                                {
                                    String tenFIle = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_GIAIQUYETDON_ST_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID,tenFIle);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }

                                }
                                // BM màn quyết định vụ việc ST
                                else if(td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_ST_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_ST_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValidBMThuLyPT(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_PT_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }   
                                // BM màn quyết định vụ việc PT
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_PT_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM màn thông tin đơn
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_THONGTINDON_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THONGTINDON_ST_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM màn bản án phúc thẩm PT
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_BANAN_PT_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }

                                //BM màn bản án sơ thẩm
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_ADS_ST(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);

                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_BANAN_ST_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                //BM màn quyết định sơ thẩm
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_QUYETDINH_ADS_ST(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_ADS(2, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                //End call API
                            }
                        }
                    }
                    else if (loaiAnId == 3)
                    {
                        DAL.GSTP.AHN_TONGDAT TONGDAT = context.AHN_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");
                        DAL.GSTP.DM_BIEUMAU bieuMau = context.DM_BIEUMAU.Where(x => x.ID == TONGDAT.BIEUMAUID).First();
                        if (bieuMau == null) return MessageResult._error("Không tìm thấy văn bản");
                        // VNPT Nguyễn Đăng Huy Hoàng  15:00 05/11/2025
                        // kiểm tra điều kiện không có tên file thì không cập nhật trạng thái tống đạt
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TRANGTHAI = 2; //đã xử lý
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                AHN_FILE objFile = new AHN_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.AHN_FILE.Add(objFile);
                                
                                TONGDAT.FILEID = objFile.ID;
                            }
                            context.SaveChanges();
                        }

                        List<AHN_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.AHN_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (AHN_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = doiTuong.NGAYPHATHANH == null ? ttDuongSuDTO.SendDate : doiTuong.NGAYPHATHANH;
                                doiTuong.NGAYPHATHANH_HETHONG = doiTuong.NGAYPHATHANH_HETHONG == null ? DateTime.Now : doiTuong.NGAYPHATHANH_HETHONG;

                                //Call API jobshare đẩy sang VNEID với thông báo án phí
                                //set thoi gian time out gọi API 30s sau thời gian đó ghi vào bảng bên JOBSHARE sẽ kiểm tra nếu chưa lưu thì lưu, nếu nưu rồi thì thôi xoa di
                                //(67: án phí ,381: lệ phí
                                AHN_TONGDAT td = dt.AHN_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).FirstOrDefault();
                                string code;
                                 if (td !=null && (td.BIEUMAUID==67||td.BIEUMAUID==381))
                                {
                                    ////Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Hôn nhân", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Hôn nhân", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                else if(td != null && td.BIEUMAUID==68)
                                {
                                    ////Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Hôn nhân", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Hôn nhân", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                // BM màn quyết định vụ việc ST án hôn nhân
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_ST_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_ST_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValidBMThuLyPT(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_PT_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }

                                // BM màn quyết định vụ việc PT án hôn nhân
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_PT_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM màn bản án phúc thẩm PT án hôn nhân
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_BANAN_PT_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM màn thông tin đơn
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_THONGTINDON_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THONGTINDON_ST_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM GIAI QUYET DON
                                else if (td != null
                                         && ENUM_PHATHANH_BIEUMAU_DS.IsValid_ADS_ST_GIAI_QUYET_DON(bieuMau.MABM))
                                {
                                    String tenFIle = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_GIAIQUYETDON_ST_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenFIle);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }

                                }
                                // Biểu mẫu màn bản án sơ thẩm
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_QUYETDINH_ADS_ST(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QUYETDINH_ST_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_ADS_ST(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);

                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_BANAN_ST_AHN(3, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);

                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }

                                //End call API

                            }
                        }
                    }
                    else if (loaiAnId == 4)
                    {
                        AKT_TONGDAT TONGDAT = context.AKT_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");
                        DM_BIEUMAU bieuMau = context.DM_BIEUMAU.Where(x => x.ID == TONGDAT.BIEUMAUID).First();
                        if (bieuMau == null) return MessageResult._error("Không tìm thấy văn bản");

                        // VNPT Nguyễn Đăng Huy Hoàng  15:00 05/11/2025
                        // kiểm tra điều kiện không có tên file thì không cập nhật trạng thái tống đạt
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TRANGTHAI = 2; //đã xử lý
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                AKT_FILE objFile = new AKT_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.AKT_FILE.Add(objFile);
                                
                                TONGDAT.FILEID = objFile.ID;
                            }
                            context.SaveChanges();
                        }

                        List<AKT_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (AKT_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = doiTuong.NGAYPHATHANH == null ? ttDuongSuDTO.SendDate: doiTuong.NGAYPHATHANH;
                                doiTuong.NGAYPHATHANH_HETHONG = doiTuong.NGAYPHATHANH_HETHONG == null ? DateTime.Now : doiTuong.NGAYPHATHANH_HETHONG;

                                //Call API jobshare đẩy sang VNEID với thông báo án phí
                                //set thoi gian time out gọi API 30s sau thời gian đó ghi vào bảng bên JOBSHARE sẽ kiểm tra nếu chưa lưu thì lưu, nếu nưu rồi thì thôi xoa di
                                //(67: án phí ,381: lệ phí
                                AKT_TONGDAT td = dt.AKT_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId ).FirstOrDefault();
                                string code;
                                if (td != null && (td.BIEUMAUID == 67 || td.BIEUMAUID == 381))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(),
                                            banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Kinh tế", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Kinh tế", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                else if (td != null && td.BIEUMAUID == 68)
                                {
                                    ///Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Kinh tế", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Kinh tế", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                // BM màn quyết định vụ việc ST án kinh tế
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_ST_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_ST_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValidBMThuLyPT(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_PT_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }

                                // BM màn quyết định vụ việc PT án hôn nhân
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_PT_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM màn bản án phúc thẩm PT án kinh tế
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_BANAN_PT_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }

                                // BM màn thông tin đơn
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_THONGTINDON_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THONGTINDON_ST_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                // BM GIAI QUYET DON
                                else if (td != null
                                         && ENUM_PHATHANH_BIEUMAU_DS.IsValid_ADS_ST_GIAI_QUYET_DON(bieuMau.MABM))
                                {
                                    String tenFIle = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_GIAIQUYETDON_ST_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenFIle);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }

                                }
                                // Biểu mẫu màn bản án sơ thẩm
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_QUYETDINH_ADS_ST(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QUYETDINH_ST_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Dân sự", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_ADS_ST(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);

                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_BANAN_ST_AKT(4, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);

                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                //End call API

                            }
                        }
                    }
                    else if (loaiAnId == 5)
                    {
                        ALD_TONGDAT TONGDAT = context.ALD_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");
                        DM_BIEUMAU bieuMau = context.DM_BIEUMAU.Where(x => x.ID == TONGDAT.BIEUMAUID).First();
                        if (bieuMau == null) return MessageResult._error("Không tìm thấy văn bản");

                        // VNPT Nguyễn Đăng Huy Hoàng  15:00 05/11/2025
                        // kiểm tra điều kiện không có tên file thì không cập nhật trạng thái tống đạt
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TRANGTHAI = 2; //đã xử lý
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                ALD_FILE objFile = new ALD_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.ALD_FILE.Add(objFile);
                                
                                TONGDAT.FILEID = objFile.ID;
                            }
                            context.SaveChanges();
                        }

                        List<ALD_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.ALD_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (ALD_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = doiTuong.NGAYPHATHANH == null ? ttDuongSuDTO.SendDate : doiTuong.NGAYPHATHANH;
                                doiTuong.NGAYPHATHANH_HETHONG = doiTuong.NGAYPHATHANH_HETHONG == null ? DateTime.Now : doiTuong.NGAYPHATHANH_HETHONG;

                                //Call API jobshare đẩy sang VNEID với thông báo án phí
                                //set thoi gian time out gọi API 30s sau thời gian đó ghi vào bảng bên JOBSHARE sẽ kiểm tra nếu chưa lưu thì lưu, nếu nưu rồi thì thôi xoa di
                                //(67: án phí ,381: lệ phí
                                ALD_TONGDAT td = dt.ALD_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId ).FirstOrDefault();
                                string code;
                                if (td != null && (td.BIEUMAUID == 67 || td.BIEUMAUID == 381))
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(),
                                            banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Lao động", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Lao động", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                else if (td != null && td.BIEUMAUID == 68)
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(),
                                            banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Lao động", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Lao động", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                // BM màn quyết định vụ việc ST án lao động
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_ST_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_ST_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValidBMThuLyPT(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_PT_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }

                                // BM màn quyết định vụ việc PT án hôn nhân
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_PT_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // BM màn bản án phúc thẩm PT án kinh tế
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_PT_ADS(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_BANAN_PT_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }

                                // BM màn thông tin đơn
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_THONGTINDON_ADS(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THONGTINDON_ST_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }
                                // BM GIAI QUYET DON
                                else if (td != null
                                         && ENUM_PHATHANH_BIEUMAU_DS.IsValid_ADS_ST_GIAI_QUYET_DON(bieuMau.MABM))
                                {
                                    String tenFIle = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_GIAIQUYETDON_ST_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenFIle);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }

                                }
                                // Biểu mẫu màn bản án sơ thẩm
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_QUYETDINH_ADS_ST(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QUYETDINH_ST_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_ADS_ST(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);

                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_VNEID_BANAN_ST_ALD(5, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);

                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }

                                //End call API

                            }
                        }
                    }
                    else if (loaiAnId == 6)
                    {
                        AHC_TONGDAT TONGDAT = context.AHC_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");
                        DM_BIEUMAU bieuMau = context.DM_BIEUMAU.Where(x => x.ID == TONGDAT.BIEUMAUID).First();
                        if (bieuMau == null) return MessageResult._error("Không tìm thấy văn bản");

                        // VNPT Nguyễn Đăng Huy Hoàng  15:00 05/11/2025
                        // kiểm tra điều kiện không có tên file thì không cập nhật trạng thái tống đạt
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TRANGTHAI = 2; //đã xử lý
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                AHC_FILE objFile = new AHC_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.AHC_FILE.Add(objFile);
                                
                                TONGDAT.FILEID = objFile.ID;
                            }
                            context.SaveChanges();
                        }

                        List<AHC_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.AHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (AHC_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = doiTuong.NGAYPHATHANH == null ? ttDuongSuDTO.SendDate : doiTuong.NGAYPHATHANH;
                                doiTuong.NGAYPHATHANH_HETHONG = doiTuong.NGAYPHATHANH_HETHONG == null ? DateTime.Now : doiTuong.NGAYPHATHANH_HETHONG;

                                //Call API jobshare đẩy sang VNEID với thông báo án phí
                                //set thoi gian time out gọi API 30s sau thời gian đó ghi vào bảng bên JOBSHARE sẽ kiểm tra nếu chưa lưu thì lưu, nếu nưu rồi thì thôi xoa di
                                //(121: án phí 
                                AHC_TONGDAT td = dt.AHC_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).FirstOrDefault();
                                string code;
                                if (td != null&& td.BIEUMAUID==121)
                                {
                                    //Call API JOBSHARED
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Hành chính", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Hành chính", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                else if (td != null && td.BIEUMAUID == 123)
                                {
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //var authService = new AuthService();
                                        //string jshtoken = authService.AuthenticateAsync().GetAwaiter().GetResult();
                                        //if (!string.IsNullOrEmpty(jshtoken))
                                        //{
                                        //    code = CallApiJobShared.jsh_ToaAnNotification(jshtoken, oData, "Hành chính", banHanhDTO.TongDatId, doiTuong.ID).GetAwaiter().GetResult();
                                        //}
                                        //else
                                        //{
                                        //    Console.WriteLine("xác thực thất bại. mã 4");
                                        //    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(4, "Hành chính", banHanhDTO.TongDatId, doiTuong.ID, oData);
                                        //}
                                    }
                                }
                                // BM màn quyết định vụ việc ST án lao động
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_ST_AHC(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_ST_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BMThuLyPT_AHC(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THULY_PT_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);
                                    }
                                }

                                // BM màn quyết định vụ việc PT án hôn nhân
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_QDVUVIEC_PT_AHC(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_QDVUVIEC_PT_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // BM màn bản án phúc thẩm PT án kinh tế
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BANAN_PT_AHC(bieuMau.MABM))
                                {
                                    //Call API JOBSHARED
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_BANAN_PT_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                                    //Co dữ liệu mới gọi API đẩy sang VNEID
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // Biểu mẫu thông tin đơn án hành chính
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_Thongtindon_AHC(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_THONGTINDON_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);
                               
                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }

                                // Biểu mẫu thông tin đơn án hành chính
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_GIAIQUYETDON_AHC(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_GIAIQUYETDON_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);

                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                // Biểu mẫu thông tin đơn án hành chính
                                else if (td != null && ENUM_PHATHANH_BIEUMAU_DS.IsValid_BM_BANAN_AHC(bieuMau.MABM))
                                {
                                    string tenBM = Cls_Comon.BuildFilename(bieuMau.TENBM);
                                    DataTable oData = VNEID_THONGBAOTA.THONGBAO_TONGDAT_BANAN_AHC(6, banHanhDTO.TongDatId, (decimal)doiTuong.ID, tenBM);

                                    if (oData != null && oData.Rows.Count > 0)
                                    {
                                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(0, loaiAnId.ToString(), banHanhDTO.TongDatId, doiTuong.ID, oData);

                                    }
                                }
                                //End call API

                            }
                        }
                    }
                    else if (loaiAnId == 7)
                    {
                        APS_TONGDAT TONGDAT = context.APS_TONGDAT.Where(x => x.ID == banHanhDTO.TongDatId).First();
                        if (TONGDAT == null) return MessageResult._error("Không tìm thấy văn bản");

                        TONGDAT.TRANGTHAI = 2; //đã xử lý
                        if (banHanhDTO.TenFile != null)
                        {
                            TONGDAT.TENFILE = banHanhDTO.TenFile;
                            TONGDAT.URL_FILE = banHanhDTO.UrlFile;
                            if (banHanhDTO.FileContent != null)
                            {
                                APS_FILE objFile = new APS_FILE();
                                objFile.NAM = DateTime.Now.Year;
                                objFile.NGAYTAO = DateTime.Now;
                                objFile.NOIDUNG = Convert.FromBase64String(banHanhDTO.FileContent);
                                objFile.TENFILE = banHanhDTO.TenFile;
                                objFile.NGUOITAO = banHanhDTO.VoUserName;
                                context.APS_FILE.Add(objFile);
                                context.SaveChanges();
                                TONGDAT.FILEID = objFile.ID;
                            }
                        }
                        List<APS_TONGDAT_DOITUONG> TONGDAT_DOITUONG = context.APS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == banHanhDTO.TongDatId).ToList();
                        foreach (APS_TONGDAT_DOITUONG doiTuong in TONGDAT_DOITUONG)
                        {
                            TTDuongSuDTO ttDuongSuDTO = ttDuongSuDTOs.Find(x => x.PartiesId == doiTuong.ID);
                            if (ttDuongSuDTO != null && doiTuong.TRANGTHAI == 1)
                            {
                                doiTuong.TRANGTHAI = 3; // đã phát hành
                                doiTuong.NGAYPHATHANH = ttDuongSuDTO.SendDate;
                                doiTuong.NGAYPHATHANH_HETHONG = DateTime.Now;
                            }
                        }
                    }
                    context.SaveChanges();
                }
                //GDKT
                else if (loaiTongDat == 2)
                {
                    if (!tongDatGdktBL.TONGDAT_GDKT_FILE_UPD(banHanhDTO.TongDatId, banHanhDTO.TenFile, banHanhDTO.UrlFile))
                    {
                        return MessageResult._error("Nhận kết quả ban hành thất bại");
                    }

                    foreach (TTDuongSuDTO duongSu in ttDuongSuDTOs)
                    {
                        if (!tongDatGdktBL.TONGDAT_GDKT_NOINHAN_PHATHANH_UPD(duongSu.PartiesId, duongSu.SendDate))
                        {
                            //do nothing
                        }
                    }
                }
                //HCTP
                else if (loaiTongDat == 3)
                {
                    if (!tongDatHctpBL.TONGDAT_HCTP_FILE_UPD(banHanhDTO.TongDatId, banHanhDTO.TenFile, banHanhDTO.UrlFile))
                    {
                        return MessageResult._error("Nhận kết quả ban hành thất bại");
                    }

                    foreach (TTDuongSuDTO duongSu in ttDuongSuDTOs)
                    {
                        if (!tongDatHctpBL.TONGDAT_HCTP_NOINHAN_PHATHANH_UPD(duongSu.PartiesId, duongSu.SendDate))
                        {
                            //do nothing
                        }
                    }
                }
                return MessageResult._success(banHanhDTO);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Đã xảy ra lỗi khi truy vấn dữ liệu.");
                if (ex.InnerException != null)
                {
                    var deepMessage = ex.InnerException?.InnerException?.Message ?? ex.InnerException?.Message ?? ex.Message;
                    Console.WriteLine("Chi tiết lỗi sâu nhất: " + deepMessage);
                    return MessageResult._error("Chi tiết lỗi sâu nhất: " + deepMessage);
                }
                else
                {
                    Console.WriteLine("Chi tiết lỗi: " + ex.Message);
                    return MessageResult._error("Chi tiết lỗi: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// API nhận trả thông tin kết quả gửi bưu điện cho QLA từ VO
        /// </summary>
        /// <param name="traKetQuaDTO">Thông tin văn bản đi</param>
        /// <returns>Kết quả sau khi phát hành văn bản</returns>
        [HttpPost]
        [Route("api/tra-ket-qua")]
        public MessageResult TraKetQua(TraKetQuaDTO traKetQuaDTO)
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }
            if (traKetQuaDTO == null) return MessageResult._error("Tham số không hợp lệ");
            long loaiAnId = traKetQuaDTO.LoaiAnId;
            long loaiTongDat = traKetQuaDTO.LoaiTongDat;
            DateTime? sendDate = traKetQuaDTO.SendDate;
            DateTime? returnDate = traKetQuaDTO.ReturnDate;
            DateTime? receiveDate = traKetQuaDTO.ReceiveDateParties;
            //ST,PT
            if (loaiTongDat == 1)
            {
                if (loaiAnId == 1)
                {
                    AHS_TONGDAT_DOITUONG TONGDAT_DOITUONG = context.AHS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID == traKetQuaDTO.PartiesId).FirstOrDefault();
                    if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS=DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                       
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                else if (loaiAnId == 2)
                {
                    ADS_TONGDAT_DOITUONG TONGDAT_DOITUONG = context.ADS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID == traKetQuaDTO.PartiesId ).FirstOrDefault();
                    if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS = DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                       
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                else if (loaiAnId == 3)
                {   //26/04/2025-----&& (x.HINHTHUCGUI==1 ||x.HINHTHUCGUI==2) (thừa phát lại hoặc qua bưu điện) sẽ không update sang quản lý án -> đã được sửa bên văn bản điều hành
                    AHN_TONGDAT_DOITUONG TONGDAT_DOITUONG = new AHN_TONGDAT_DOITUONG();
                    try
                    {
                        TONGDAT_DOITUONG = context.AHN_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID == traKetQuaDTO.PartiesId ).FirstOrDefault();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Đã xảy ra lỗi khi truy vấn dữ liệu.");

                        if (ex.InnerException != null)
                        {
                            Console.WriteLine("Chi tiết lỗi (InnerException): " + ex.InnerException.Message);
                        }
                        else
                        {
                            Console.WriteLine("Chi tiết lỗi: " + ex.Message);
                        }
                    }
                if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");                  
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS = DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                      
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                else if (loaiAnId == 4)
                {
                    AKT_TONGDAT_DOITUONG TONGDAT_DOITUONG = context.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID == traKetQuaDTO.PartiesId ).FirstOrDefault();
                    if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS = DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                       
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                else if (loaiAnId == 5)
                {
                    ALD_TONGDAT_DOITUONG TONGDAT_DOITUONG = context.ALD_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID == traKetQuaDTO.PartiesId).FirstOrDefault();
                    if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS = DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                      
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                else if (loaiAnId == 6)
                {
                    AHC_TONGDAT_DOITUONG TONGDAT_DOITUONG = context.AHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID== traKetQuaDTO.PartiesId).FirstOrDefault();
                    if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS = DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                       
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                else if (loaiAnId == 7)
                {
                    APS_TONGDAT_DOITUONG TONGDAT_DOITUONG = context.APS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == traKetQuaDTO.TongDatId && x.ID == traKetQuaDTO.PartiesId ).FirstOrDefault();
                    if (TONGDAT_DOITUONG == null) return MessageResult._error("Không tìm thấy đối tượng");
                    if (receiveDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = receiveDate;
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT_SYS = DateTime.Now;
                        TONGDAT_DOITUONG.TRANGTHAI = 4; // Phát hành thành công
                    }
                    else if (returnDate != null && TONGDAT_DOITUONG.TRANGTHAI == 3)
                    {
                        TONGDAT_DOITUONG.NGAYNHANTONGDAT = returnDate;                      
                        TONGDAT_DOITUONG.TRANGTHAI = 5; // Phát hành không thành công
                    }
                }
                context.SaveChanges();
            }
            //GDKT
            else if (loaiTongDat == 2)
            {
                decimal? trangThai = null;
                DateTime ngayNhan = DateTime.Now;
                string lyDo = null;
                if (receiveDate != null)
                {
                    trangThai = 4; // Phát hành thành công
                    ngayNhan = receiveDate ?? DateTime.Now;
                }
                else if (returnDate != null)
                {
                    trangThai = 5; // Phát hành không thành công
                    ngayNhan = returnDate ?? DateTime.Now;
                    lyDo = traKetQuaDTO.Reason;
                }

                if (!tongDatGdktBL.TONGDAT_GDKT_NOINHAN_TRAKETQUA(traKetQuaDTO.PartiesId, trangThai, ngayNhan, lyDo))
                {
                    return MessageResult._error("Trả kết quả thất bại");
                }
            }
            //HCTP
            else if (loaiTongDat == 3)
            {
                decimal? trangThai = null;
                DateTime ngayNhan = DateTime.Now;
                string lyDo = null;
                if (receiveDate != null)
                {
                    trangThai = 4; // Phát hành thành công
                    ngayNhan = receiveDate ?? DateTime.Now;
                }
                else if (returnDate != null)
                {
                    trangThai = 5; // Phát hành không thành công
                    ngayNhan = returnDate ?? DateTime.Now;
                    lyDo = traKetQuaDTO.Reason;
                }

                if (!tongDatHctpBL.TONGDAT_HCTP_NOINHAN_TRAKETQUA(traKetQuaDTO.PartiesId, trangThai, ngayNhan, lyDo))
                {
                    return MessageResult._error("Trả kết quả thất bại");
                }
            }
            return MessageResult._success(traKetQuaDTO);
        }

        [HttpGet]
        [Route("api/tongdat")]
        public MessageResult TongDat()
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }

            List<TongDatDTO> allAn = new List<TongDatDTO>();
            // Án hình sự
            List<TongDatDTO> anHinhSu = GetAnHinhSu();
            allAn.AddRange(anHinhSu);
            // Án dân sự
            List<TongDatDTO> anDanSu = GetAnDanSu();
            allAn.AddRange(anDanSu);
            // Án hôn nhân và gia đình
            List<TongDatDTO> anHonNhanGiaDinh = GetAnHonNhanGiaDinh();
            allAn.AddRange(anHonNhanGiaDinh);
            // Án kinh doanh thương mại
            List<TongDatDTO> anKdtm = GetAnKDTM();
            allAn.AddRange(anKdtm);
            // Án lao động
            List<TongDatDTO> anLaoDong = GetAnLaoDong();
            allAn.AddRange(anLaoDong);
            // Án hành chính
            List<TongDatDTO> anHanhChinh = GetAnHanhChinh();
            allAn.AddRange(anHanhChinh);
            // Án phá sản
            List<TongDatDTO> anPhaSan = GetAnPhaSan();
            allAn.AddRange(anPhaSan);

            return MessageResult._success(allAn);
        }

        // Án phá sản
        private List<TongDatDTO> GetAnPhaSan()
        {
            List<APS_TONGDAT> adsTongDats = context.APS_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<APS_TONGDAT_DOITUONG> allDoiTuongs = context.APS_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();
            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, APS_DON_DUONGSU> donDuongSu = context.APS_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            APS_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<APS_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        // Án hành chính
        private List<TongDatDTO> GetAnHanhChinh()
        {
            List<AHC_TONGDAT> adsTongDats = context.AHC_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AHC_TONGDAT_DOITUONG> allDoiTuongs = context.AHC_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, AHC_DON_DUONGSU> donDuongSu = context.AHC_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            AHC_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<AHC_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        // Án lao động
        private List<TongDatDTO> GetAnLaoDong()
        {
            List<ALD_TONGDAT> adsTongDats = context.ALD_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<ALD_TONGDAT_DOITUONG> allDoiTuongs = context.ALD_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, ALD_DON_DUONGSU> donDuongSu = context.ALD_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            ALD_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<ALD_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        // Án KDTM
        private List<TongDatDTO> GetAnKDTM()
        {
            List<AKT_TONGDAT> adsTongDats = context.AKT_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AKT_TONGDAT_DOITUONG> allDoiTuongs = context.AKT_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, AKT_DON_DUONGSU> donDuongSu = context.AKT_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            AKT_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<AKT_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        // Án hôn nhân gia đình
        private List<TongDatDTO> GetAnHonNhanGiaDinh()
        {
            List<AHN_TONGDAT> adsTongDats = context.AHN_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AHN_TONGDAT_DOITUONG> allDoiTuongs = context.AHN_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, AHN_DON_DUONGSU> donDuongSu = context.AHN_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            AHN_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<AHN_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        // Án dân sự
        private List<TongDatDTO> GetAnDanSu()
        {
            List<DAL.GSTP.ADS_TONGDAT> adsTongDats = context.ADS_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<ADS_TONGDAT_DOITUONG> allDoiTuongs = context.ADS_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, ADS_DON_DUONGSU> donDuongSu = context.ADS_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            ADS_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<ADS_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        // Án hình sự
        private List<TongDatDTO> GetAnHinhSu()
        {
            List<AHS_TONGDAT> ahsTongDats = context.AHS_TONGDAT.ToList();
            List<TongDatDTO> danhSachTongDat = ahsTongDats.Select(x => ToDTO(x)).ToList();
            Dictionary<decimal, TongDatDTO> mapTongDat = new Dictionary<decimal, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AHS_TONGDAT_DOITUONG> allDoiTuongs = context.AHS_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.ID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, AHS_BICANBICAO> donDuongSu = context.AHS_BICANBICAO
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            AHS_BICANBICAO defaultBiCao;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<AHS_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID)).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultBiCao) ? defaultBiCao : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        private TongDatDTO ToDTO<T>(T model)
        {
            if (model == null)
                return null;

            // mapping án hình sự
            if (model.GetType() == typeof(AHS_TONGDAT))
            {
                AHS_TONGDAT entity = model as AHS_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_HINH_SU;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.VUANID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            // mapping án dân sự
            if (model.GetType() == typeof(DAL.GSTP.ADS_TONGDAT))
            {
                DAL.GSTP.ADS_TONGDAT entity = model as DAL.GSTP.ADS_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_DAN_SU;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            // mapping án hôn nhân
            if (model.GetType() == typeof(AHN_TONGDAT))
            {
                AHN_TONGDAT entity = model as AHN_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_HON_NHAN_GIA_DINH;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            // mapping án KDTM
            if (model.GetType() == typeof(AKT_TONGDAT))
            {
                AKT_TONGDAT entity = model as AKT_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_KDTM;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            // mapping án lao động
            if (model.GetType() == typeof(ALD_TONGDAT))
            {
                ALD_TONGDAT entity = model as ALD_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_LAO_DONG;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            // mapping án hành chính
            if (model.GetType() == typeof(AHC_TONGDAT))
            {
                AHC_TONGDAT entity = model as AHC_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_HANHCHINH;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            // mapping án phá sản
            if (model.GetType() == typeof(APS_TONGDAT))
            {
                APS_TONGDAT entity = model as APS_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = AN_PHA_SAN;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                return dto;
            }

            return null;
        }

        private DoiTuongDTO ToDTO<T, E>
            (
            TongDatDTO entityTongDat,
            T model,
            E duongSuModel
            )
        {
            if (model == null)
                return null;

            // mapping án hình sự
            if (model.GetType() == typeof(AHS_TONGDAT_DOITUONG))
            {
                AHS_TONGDAT_DOITUONG entity = model as AHS_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;

                dto.QuocGia = entity.QUOCGIA;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    AHS_BICANBICAO biCao = duongSuModel as AHS_BICANBICAO;
                    dto.TenDuongSu = biCao.HOTEN;
                    dto.SoCMND = biCao.SOCMND;
                    dto.QuocTichId = biCao.QUOCTICHID;
                    dto.TinhId = biCao.TAMTRU ?? biCao.HKTT;
                    dto.HuyenId = biCao.TAMTRU_HUYEN ?? biCao.HKTT_HUYEN;
                    dto.DiaChiChiTiet = biCao.TAMTRUCHITIET ?? biCao.KHTTCHITIET;
                    dto.NamSinh = biCao.NAMSINH;
                }

                return dto;
            }

            // mapping án dân sự
            if (model.GetType() == typeof(ADS_TONGDAT_DOITUONG))
            {
                ADS_TONGDAT_DOITUONG entity = model as ADS_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    ADS_DON_DUONGSU duongSu = duongSuModel as ADS_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }

                return dto;
            }

            // mapping án hôn nhân và gia đình
            if (model.GetType() == typeof(AHN_TONGDAT_DOITUONG))
            {
                AHN_TONGDAT_DOITUONG entity = model as AHN_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    AHN_DON_DUONGSU duongSu = duongSuModel as AHN_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }

                return dto;
            }

            // mapping án KDTM
            if (model.GetType() == typeof(AKT_TONGDAT_DOITUONG))
            {
                AKT_TONGDAT_DOITUONG entity = model as AKT_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    AKT_DON_DUONGSU duongSu = duongSuModel as AKT_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }

                return dto;
            }

            // mapping án lao động
            if (model.GetType() == typeof(ALD_TONGDAT_DOITUONG))
            {
                ALD_TONGDAT_DOITUONG entity = model as ALD_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    ALD_DON_DUONGSU duongSu = duongSuModel as ALD_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }

                return dto;
            }

            // mapping án hành chính
            if (model.GetType() == typeof(AHC_TONGDAT_DOITUONG))
            {
                AHC_TONGDAT_DOITUONG entity = model as AHC_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    AHC_DON_DUONGSU duongSu = duongSuModel as AHC_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }

                return dto;
            }

            // mapping án phá sản
            if (model.GetType() == typeof(APS_TONGDAT_DOITUONG))
            {
                APS_TONGDAT_DOITUONG entity = model as APS_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;

                if (duongSuModel != null)
                {
                    APS_DON_DUONGSU duongSu = duongSuModel as APS_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }

                return dto;
            }
            return null;
        }

    }
}