using BL.GSTP;
using DAL.GSTP;
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
using WEB.GSTP.QLAN.GDTTT.In;
using WEB.GSTP.QLAN.GDTTT.In.DTGDTTTTableAdapters;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.Thongke
{
    public partial class ThongKeAnQuocHoi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                   // txtNgay_Den.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    LoadDrop();
                    SetTieuDeBaoCao();
                    LoadReport();
                }
            }
            catch (Exception ex) { lttMsg.Text = "<div class='msg_error'>"+ex.Message+"</div>"; }
        }
        void LoadDrop()
        {
            decimal DonViID = String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "") ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            decimal PBID = String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "") ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            //Load Thẩm phán
            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //Lãnh đạo
            try { LoadDropLanhDao(); } catch (Exception ex) { }
            //--------------------------------------------
            //Load loại công văn
            DM_DATAITEM_BL cvBL = new DM_DATAITEM_BL();
            DataTable tbl = cvBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAICVGDTTT);
            if (tbl.Rows.Count > 0)
            {
                ddlCongVan.DataSource = tbl;
                ddlCongVan.DataTextField = "MA_TEN";
                ddlCongVan.DataValueField = "ID";
                ddlCongVan.DataBind();
            }
            ddlCongVan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            LoadDropLoaiAn();
        }

        void LoadDropLanhDao()
        {
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            decimal chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
            decimal chucvu_id = (string.IsNullOrEmpty(oCB.CHUCVUID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCVUID);
            if (chucvu_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).FirstOrDefault();
                if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT)
                {
                    ddlPhoVuTruong.Items.Clear();
                    ddlPhoVuTruong.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));

                    hddLoaiTK.Value = ENUM_CHUCVU.CHUCVU_PVT;
                    //----------------------
                    LoadDropTTV_TheoLanhDao();
                }
                else
                {
                    Load_AllLanhDao();
                    if (oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV)
                    {
                        ddlThamtravien.Items.Clear();
                        ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                    }
                    else LoadAll_TTV();
                }
            }
            else if (chucdanh_id > 0)
            {
                Load_AllLanhDao();

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).Single();
                //if (oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV || oCD.MA == "TTVC" && loai_hotro_db != 1)
                if (oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV && loai_hotro_db != 1)
                {
                    ddlThamtravien.Items.Clear();
                    ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                }
                else LoadAll_TTV();
            }            
        }
        void Load_AllLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();

            //DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(LoginDonViID, PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
            DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, "LDV");
            ddlPhoVuTruong.DataSource = tbl;
            ddlPhoVuTruong.DataTextField = "HOTEN";
            ddlPhoVuTruong.DataValueField = "ID";
            ddlPhoVuTruong.DataBind();
            ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        void LoadAll_TTV()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //Thẩm tra viên
            DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
                     

            ddlThamtravien.DataSource = tblTheoPB;
            ddlThamtravien.DataTextField = "HOTEN";
            ddlThamtravien.DataValueField = "ID";
            ddlThamtravien.DataBind();
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        void LoadDropTTV_TheoLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PhongBanID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            ddlThamtravien.Items.Clear();
            Decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            try
            {
                DM_CANBO_BL obj = new DM_CANBO_BL();

                DataTable tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, 0, 1, 200000);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ddlThamtravien.DataSource = tbl;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "CanBoID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
            catch (Exception ex)
            { }
        }
        void LoadDropThamphan()
        {
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }
        void LoadDropLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1)
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
               
        protected void btnXemBC_Click(object sender, EventArgs e)
        {
            try
            {
                //SetTieuDeBaoCao();
                LoadReport();
            }
            catch (Exception ex) { }
            //lttMsg.Text = "<div class='msg_error'>" + ex.Message+"</div>"; 
        }
        private void LoadReport()
        {
            lttMsg.Text = "";
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            string TenPhongBan = oPB.TENPHONGBAN;
            decimal dLoaiCV = Convert.ToDecimal(ddlCongVan.SelectedValue);
            decimal dKQTL = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal ThamtraVienID = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal thamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);

            String ThoiGian = "";
            if (vNgayTu == (DateTime?)null && vNgayDen == (DateTime?)null)
                ThoiGian = "(Tính đến ngày " + DateTime.Now.ToString("dd/MM/yyyy", cul) + ")";
            else
            {
                ThoiGian = "(";
                if (vNgayTu != (DateTime?)null && vNgayDen != (DateTime?)null)
                {
                    ThoiGian += "Từ ngày " + Convert.ToDateTime(vNgayTu).ToString("dd/MM/yyyy", cul);
                    ThoiGian += " đến ngày " + Convert.ToDateTime(vNgayDen).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    if (vNgayTu != (DateTime?)null)
                    {
                        ThoiGian += "Từ ngày " + Convert.ToDateTime(vNgayTu).ToString("dd/MM/yyyy", cul);
                        ThoiGian += " đến ngày " + DateTime.Now.ToString("dd/MM/yyyy", cul) ;
                    }
                    else
                    {
                        ThoiGian += "Tính đến ngày " + Convert.ToDateTime(vNgayDen).ToString("dd/MM/yyyy", cul);
                    }
                }
                ThoiGian += ")";
            }

            decimal LoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            String coquanCD = txtCoQuanChuyenDon.Text.Trim().ToLower();
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            DataTable tblData = objBL.GDTTTT_THONGKE_ANQUOCHOI(ToaAnID, PBID,LoaiAn
                                                            , ThamtraVienID, LanhDaoID,thamphanID
                                                            , dLoaiCV, dKQTL
                                                            , vNgayTu, vNgayDen
                                                            , coquanCD);

            rptThongKeAnQuocHoi bc = new rptThongKeAnQuocHoi();
            bc.Parameters["TieuDe"].Value = (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()) ? "Danh sách án quốc hội" : txtTieuDeBC.Text.Trim()).ToUpper(); 
            bc.Parameters["TenPhongban"].Value = TenPhongBan;
            bc.Parameters["ThoiGian"].Value = ThoiGian;
            bc.Parameters["TongSo"].Value = tblData.Rows.Count +" vụ án";
            bc.DataSource = tblData;
            rptView.OpenReport(bc);

            //int countall = (tblData != null && tblData.Rows.Count > 0) ? 0 : tblData.Rows.Count;
            //lttMsg.Text = "Tìm thấy "+ tblData.Rows.Count+" vụ";
        }
        private bool CheckData()
        {
            string TuNgay = txtNgay_Tu.Text;
            if (TuNgay == "")
            {
                lttMsg.Text = "<div class='msg_error'>Chưa nhập từ ngày. Hãy nhập lại!</div>";
                Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lttMsg.Text = "<div class='msg_error'>Chưa nhập từ ngày đúng theo định dạng (Ngày / Tháng / Năm). Hãy nhập lại!</div>";
                    Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                    return false;
                }
            }
            return true;
        }
        void SetTieuDeBaoCao()
        {       
            string tieudebc = "";

            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " là án " + ddlLoaiAn.SelectedItem.Text.ToLower();
            //-------------------------------------
            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);

            if (ddlPhoVuTruong.SelectedValue != "0")
                canbophutrach += ((string.IsNullOrEmpty(canbophutrach)) ? "" : ", ") + "lãnh đạo Vụ " + Cls_Comon.FormatTenRieng(ddlPhoVuTruong.SelectedItem.Text);

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-------------------------------------
            int kq = Convert.ToInt16(ddlKetquaThuLy.SelectedValue);
            if (kq != 3)
            {
                if (kq == 4 || kq == 5)
                    tieudebc += " " + ddlKetquaThuLy.SelectedItem.Text.ToLower();
                else tieudebc += " có kết quả giải quyết là " + ddlKetquaThuLy.SelectedItem.Text.ToLower().Replace("...","");
            }
            //-------------------------
            if (ddlCongVan.SelectedValue != "0")
                tieudebc += " có loại công văn là " + ddlCongVan.SelectedItem.Text.ToLower();
            
            txtTieuDeBC.Text = ("Danh sách các vụ án quốc hội " + tieudebc).Trim();
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            LoadReport();
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            LoadReport();
        }
        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            LoadReport();
        }
        protected void ddlThamtravien_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            LoadReport();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            LoadReport();
        }
        

    }
}