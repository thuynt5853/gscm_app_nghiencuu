using BL.GSTP;
using BL.GSTP.AHN;
using BL.GSTP.AHS;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHN.Hoso.Popup
{
    /*GTEL-DUCPH 18-09-2025 17h Thêm POPUP hiển thị lịch sử sửa đổi thông tin bị can*/
    public partial class pHisBiCao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal BiCanId = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                BiCanId = (String.IsNullOrEmpty(Request["biCanID"] + "")) ? 0 : Convert.ToDecimal(Request["biCanID"] + "");
                if (BiCanId > 0)
                {
                    AHS_BICANBICAO_NC_BL bl = new AHS_BICANBICAO_NC_BL();
                    DataTable tbl = bl.AHS_BICAN_HISTORY_GETLIST(BiCanId);
                    List<AHS_BICAN_HISTORY_MODEL> datas = new List<AHS_BICAN_HISTORY_MODEL>();
                    if (tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                        {
                            string jsonObj = row["HIS_BICAN"].ToString();
                            AHS_BICANBICAO model = JsonConvert.DeserializeObject<AHS_BICANBICAO>(jsonObj);
                            AHS_BICAN_HISTORY_MODEL item = new AHS_BICAN_HISTORY_MODEL();
                            item.HIS_NGUOISUA = row["HIS_NGUOISUA"].ToString();
                            item.HIS_TAIKHOANSUA = row["HIS_TAIKHOANSUA"].ToString();
                            item.DIACHI = LayDiaChiTamTru(model);
                            item.HIS_NGAYSUA = row["HIS_NGAYSUA"].ToString();
                            item.TEN_BICAN = model.HOTEN;
                            item.NGAYTAO = model.NGAYTAO.HasValue ? model.NGAYTAO.Value.ToString("dd-MM-yyyy") : string.Empty;
                            item.NGUOITAO = model.NGUOITAO;
                            item.TOIDANH = LayToiDanh(model.ID, model.VUANID ?? model.VUANID.Value);
                            item.TRANGTHAIXACTHUC = LayTrangThaiXacThuc(model.XACTHUC_DLDCQG);
                            datas.Add(item);
                        }
                    }
                    dgList.DataSource = datas;
                    dgList.DataBind();
                }
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

            }
        }
        // GTEL-DUCPH 22-09-2025 Lấy địa chỉ tạm trú của Bị Can
        private string LayDiaChiTamTru(AHS_BICANBICAO model)
        {
            string diaChi = string.Empty;
            //string jsonObj = row["NOIDUNG"].ToString();
            //AHS_BICAN_MODEL model = JsonConvert.DeserializeObject<AHS_BICAN_MODEL>(jsonObj);
            if (model != null && model != null)
            {
                // Lấy thông tin xã/phường
                string xaPhuong = "";
                if (!string.IsNullOrEmpty(model.TAMTRU_HUYEN.ToString()))
                {
                    DM_HANHCHINH dmXaPhuong = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == model.TAMTRU_HUYEN);
                    if (dmXaPhuong != null) xaPhuong = dmXaPhuong.TEN;
                }
                // Lấy thông tin tỉnh
                string tinh = "";
                if (!string.IsNullOrEmpty(model.TAMTRU.ToString()))
                {
                    DM_HANHCHINH dmTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == model.TAMTRU);
                    if (dmTinh != null) tinh = dmTinh.TEN;
                }
                diaChi = model.TAMTRUCHITIET + ", " + xaPhuong + ", " + tinh;
            }
            return diaChi;
        }

        //GTEL-DUCPH 22-09-2025 lấy tội danh bị can
        private string LayToiDanh(decimal biCanId, decimal vuAnId)
        {
            AHS_BICANBICAO_NC_BL bl = new AHS_BICANBICAO_NC_BL();
            DataTable tbl = bl.AHS_TOIDANH_CHINH_GETBYBICAN(biCanId, vuAnId);
            if(tbl.Rows.Count > 0)
            {
                string toiDanh = tbl.Rows[0]["TENTOIDANH"].ToString();
                return toiDanh;
            }
            return string.Empty;
        }
        //GTEL-DUCPH 22-09-2025 lấy trạng thái xác thực
        private string LayTrangThaiXacThuc(string val)
        {
            switch (val)
            {
                case "0":
                    return "Chưa xác thực";
                case "1":
                    return "Đã xác thực";
                case "2":
                    return "Không thể làm sạch được";
                default: return string.Empty;
            }
        }
    }
}