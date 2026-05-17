using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.UserControl.TP
{
    public partial class DanhSachAn : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadThongTin();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadDanhSach();
                }
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        private void LoadThongTin()
        {
            LtrCapXetXu.Text = Request["cxx"] + "" == "ST" ? "Sơ thẩm" : "Phúc thẩm";
            string LoaiAn = "", ThongTinThongKe = "";
            switch (Request["loa"] + "")
            {
                case "AHS":
                    LoaiAn = "Hình sự";
                    break;
                case "AHS_CHUA_THANH_NIEN":
                    LoaiAn = "Án hình sự chưa thành niên";
                    break;
                case "ADS":
                    LoaiAn = "Dân sự";
                    break;
                case "AKT":
                    LoaiAn = "Kinh doanh, Thương mại";
                    break;
                case "AHC":
                    LoaiAn = "Hành chính";
                    break;
                case "AHN":
                    LoaiAn = "Hôn nhân và Gia đình";
                    break;
                case "ALD":
                    LoaiAn = "Lao động";
                    break;
                case "APS":
                    LoaiAn = "Phá sản";
                    break;
                case "XLHC":
                    LoaiAn = "Biện pháp XLHC";
                    break;
                default:
                    LoaiAn = "";
                    break;
            };
            LtrLoaiAn.Text = LoaiAn;
            switch (Request["ttk"] + "")
            {
                case "NHAPVUAN":
                    ThongTinThongKe = "Nhập vụ án";
                    break;
                case "CHUYENVUAN":
                    ThongTinThongKe = "Chuyển vụ án";
                    break;
                case "AN_TON":
                    ThongTinThongKe = "Án tồn chuyển sang";
                    break;
                case "AN_CHO_THU_LY":
                    ThongTinThongKe = "Án chờ thụ lý";
                    break;
                case "AN_THU_LY_CHUA_PC":
                    ThongTinThongKe = "Án đã thụ lý >> Chưa phân công TP";
                    break;
                case "AN_THU_LY_DA_PC":
                    ThongTinThongKe = "Đã thụ lý >> Đã phân công TP";
                    break;
                case "DA_LEN_LICH_XET_XU":
                    ThongTinThongKe = "Đã lên lịch xét xử";
                    break;
                case "DA_GIAI_QUYET":
                    ThongTinThongKe = "Đã giải quyết";
                    break;
                case "CON_LAI":
                    ThongTinThongKe = "Còn lại (Chưa GQ xong)";
                    break;
                case "AN_TDC":
                    ThongTinThongKe = "Án tạm đình chỉ";
                    break;
                case "AN_SUA_HUY":
                    ThongTinThongKe = "Án bị sửa/hủy";
                    break;
                case "AN_QH_DANG_GQ":
                    ThongTinThongKe = "Án quá hạn đang giải quyết";
                    break;
                case "AN_QH_DA_GQ":
                    ThongTinThongKe = "Án quá hạn đã giải quyết";
                    break;
                default:
                    ThongTinThongKe = "";
                    break;
            };
            LtrThongTinThongKe.Text = ThongTinThongKe;
        }
        private void LoadDanhSach()
        {
            string CapXetXu= Request["cxx"] + "", LoaiAn = Request["loa"] + "", ThongTinThongKe = Request["ttk"] + "";
            DateTime TuNgay = DateTime.Parse("01/01/" + DateTime.Now.Year.ToString() + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse("31/12/" + DateTime.Now.Year.ToString() + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_TOAANID",ToaAnID),
                new OracleParameter("v_CAP_XET_XU",CapXetXu),
                new OracleParameter("v_LOAIAN",LoaiAn),
                new OracleParameter("V_NHOM_THONG_KE",ThongTinThongKe),
                new OracleParameter("v_DATE_TUNGAY",TuNgay),
                new OracleParameter("v_DATE_DENNGAY",DenNgay),
                new OracleParameter("curReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("HOME_CA_LIST_VUAN", prm);
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(tbl.Rows.Count), dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + tbl.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            dgList.DataSource = tbl;
            dgList.DataBind();
            Session["HOME_CA_CAPXETXU"] = CapXetXu;
            Session["HOME_CA_LOAIAN"] = LoaiAn;
            Session["HOME_CA_NHOM_THONG_KE"] = ThongTinThongKe;
            Session["HOME_CA_LIST_VUAN"] = tbl;
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = dgList.CurrentPageIndex - 1;
                hddPageIndex.Value = (dgList.CurrentPageIndex + 1).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDanhSach();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        #endregion
        protected void LbtBackHome_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/Trangchu.aspx";
            Response.Redirect(link);
        }

        protected void cmdInBaoCao_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_inbaocao_danhsach()");
        }
    }
}