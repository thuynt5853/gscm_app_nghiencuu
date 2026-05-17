using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Web.Http;
using WEB.Service.Controllers.Utils;
using WEB.Service.Models;
using WEB.Service.Models.DM_VOFFICE;

namespace WEB.Service.Controllers
{
    public class WS_ThongTinCanBoController : ApiController
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");

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

        /// <summary>
        /// Hàm kiểm tra token hợp lệ
        /// </summary>
        /// <param name="token">Token kiểm tra</param>
        /// <returns>Trả về true nếu token hợp lệ, false nếu không hợp lệ</returns>
        private bool isAccesable(string tokenKey)
        {
            DM_TOKEN_KEY oTokenKey = dt.DM_TOKEN_KEY.Where(x => x.TOKEN_KEY.ToLower() == tokenKey.ToLower()).FirstOrDefault<DM_TOKEN_KEY>();
            if (oTokenKey != null)
                return oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            return false;
        }

        String QueryCanBo = "SELECT dc.*, dp.tenphongban AS TenPhongBan, dps.tenphongban AS TenPhongBanCon, dd.ten AS TenChucVu, dd1.ten AS TenChucDanh " +
            " FROM GSCM.DM_CANBO dc " +
            " LEFT JOIN GSCM.DM_PHONGBAN dp ON dc.PHONGBANID  = dp.ID " +
            " LEFT JOIN GSCM.DM_PHONGBAN dps ON dc.PHONGBANID_SUB = dps.ID " +
            " LEFT JOIN GSCM.DM_DATAITEM dd ON dc.CHUCVUID = dd.ID " +
            " LEFT JOIN GSCM.DM_DATAITEM dd1 ON dc.CHUCDANHID  = dd1.ID " +
            " WHERE (dc.NGAYTAO >= TO_DATE(:requestDate, 'YYYY-MM-DD HH24:MI:SS') OR dc.NGAYSUA >= TO_DATE(:requestDate, 'YYYY-MM-DD HH24:MI:SS'))";

        String QueryCanBoALL = "SELECT dc.*, dp.tenphongban AS TenPhongBan, dps.tenphongban AS TenPhongBanCon, dd.ten AS TenChucVu, dd1.ten AS TenChucDanh " +
            " FROM GSCM.DM_CANBO dc " +
            " LEFT JOIN GSCM.DM_PHONGBAN dp ON dc.PHONGBANID  = dp.ID " +
            " LEFT JOIN GSCM.DM_PHONGBAN dps ON dc.PHONGBANID_SUB = dps.ID " +
            " LEFT JOIN GSCM.DM_DATAITEM dd ON dc.CHUCVUID = dd.ID " +
            " LEFT JOIN GSCM.DM_DATAITEM dd1 ON dc.CHUCDANHID  = dd1.ID ";

        /// <summary>
        /// API đồng bộ thông tin cán bộ
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Danh sách cán bộ</returns>
        [HttpGet]
        [Route("api/ps/getgroupUserInfo")]
        public DM_Response Get(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response Res = new DM_Response();
                Res.Message = "01";
                Res.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return Res;
            }
            DM_Response Response = new DM_Response();
            Response.Message = "00";
            Response.RequestTime = requestTime;
            Response.Note = "Thành công";
            if (requestTime != null)
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                List<OracleParameter> Params = new List<OracleParameter>();
                Params.Add(new OracleParameter("requestDate", requestDate.ToString("yyyy-MM-dd hh:mm:ss")));
                DataTable dt = Cls_Comon.GetTableToSQL(QueryCanBo, Params);
                ConvertCanBo(Response, dt);
            }
            else
            {
                DataTable dt = Cls_Comon.GetTableToSQL(QueryCanBoALL);
                ConvertCanBo(Response, dt);
            }

            return Response;
        }

        /// <summary>
        /// Hàm convert dữ liệu lấy từ DB
        /// </summary>
        /// <param name="Response">Response trả về</param>
        /// <param name="dt">Dữ liệu lấy từ DB</param>
        private static void ConvertCanBo(DM_Response Response, DataTable dt)
        {
            List<DM_CanBo> canbos = new List<DM_CanBo>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                DM_CanBo cb = new DM_CanBo();
                cb.Id = Convert.ToInt64(dt.Rows[i]["ID"]);
                // cb.UserName = dt.Rows[i]["MACANBO"].ToString();
                cb.FullName = dt.Rows[i]["HOTEN"].ToString();
                cb.Gender = dt.Rows[i]["GIOITINH"].ToString();
                cb.Phone = dt.Rows[i]["SODIENTHOAI"].ToString();
                //cb.Email = dt.Rows[i]["EMAIL"].ToString();
                cb.IdNumber = dt.Rows[i]["SOCMND"].ToString();

                if (dt.Rows[i]["CHUCVUID"] != DBNull.Value)
                    cb.RoleId = Convert.ToInt64(dt.Rows[i]["CHUCVUID"]);
                cb.RoleName = dt.Rows[i]["TENCHUCVU"].ToString();

                if (dt.Rows[i]["CHUCDANHID"] != DBNull.Value)
                    cb.PosId = Convert.ToInt64(dt.Rows[i]["CHUCDANHID"]);
                cb.PosName = dt.Rows[i]["TENCHUCDANH"].ToString();

                if (dt.Rows[i]["PHONGBANID_SUB"] != DBNull.Value && Convert.ToInt64(dt.Rows[i]["PHONGBANID_SUB"]) != 0)
                {
                    cb.DeptId = Convert.ToInt64(dt.Rows[i]["PHONGBANID_SUB"]);
                    cb.DeptName = dt.Rows[i]["TENPHONGBANCON"].ToString();

                    if (dt.Rows[i]["PHONGBANID"] != DBNull.Value)
                        cb.ParentDeptId = Convert.ToInt64(dt.Rows[i]["PHONGBANID"]);
                }
                else
                {
                    if (dt.Rows[i]["PHONGBANID"] != DBNull.Value)
                        cb.DeptId = Convert.ToInt64(dt.Rows[i]["PHONGBANID"]);
                    cb.DeptName = dt.Rows[i]["TENPHONGBAN"].ToString();

                    if (dt.Rows[i]["TOAANID"] != DBNull.Value)
                        cb.ParentDeptId = Convert.ToInt64(dt.Rows[i]["TOAANID"]);
                }
                
                try
                {
                    cb.Status = Convert.ToInt64(dt.Rows[i]["HIEULUC"]);
                }
                catch (Exception ex)
                {
                    cb.Status = 0;
                }
                canbos.Add(cb);
            }
            DM_CanBoResponse CanboResponse = new DM_CanBoResponse();
            CanboResponse.Members = canbos;
            Response.Data = CanboResponse;
        }
    }
}
