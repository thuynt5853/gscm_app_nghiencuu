using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Collections.Generic;


namespace WEB.GSTP.PCTP
{
    public partial class PhanCongNgauNhien : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //try
                //{
                DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
               DataTable odtCA= oDMCBBL.DM_CANBO_GETBYDONVI_CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA);
                if(odtCA.Rows.Count>0)
                {
                    hddCA_ID.Value = odtCA.Rows[0]["ID"] + "";
                    txtNguoiphancong.Text = odtCA.Rows[0]["MA_TEN"] + "";
                }
                decimal ChanhAnID = Convert.ToDecimal(hddCA_ID.Value);
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                txtToaan.Text = oTA.MA_TEN;
                hddLoaiToa.Value = oTA.LOAITOA;
                if (oTA.LOAITOA== "CAPHUYEN")
                {
                    chkPhucTham.Checked = false;
                    chkPhucTham.Enabled = false;
                    chkThanhvien.Checked = false;
                    chkThanhvien.Enabled = false;
                    rptCapTinh.Visible = false;
                    rptGQD.Visible = true;
                }
                else
                {
                    chkPhucTham.Checked = true;
                    chkPhucTham.Enabled = true;
                    chkThanhvien.Checked = true;
                    chkThanhvien.Enabled = true;
                    rptCapTinh.Visible = true;
                    rptGQD.Visible = false;
                }
                txtNgayphancong.Text =  DateTime.Now.ToString("dd/MM/yyyy", cul);
               
                txtTuNgay.Text = DateTime.Now.AddDays(-5).ToString("dd/MM/yyyy", cul);
                txtDenNgay.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

                txtGQVVTu.Text = DateTime.Now.AddDays(-5).ToString("dd/MM/yyyy", cul);
                txtGQVVDen.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

                txtTVXXTu.Text = DateTime.Now.AddDays(-5).ToString("dd/MM/yyyy", cul);
                txtTVXXDen.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

                txtThukyTu.Text = DateTime.Now.AddDays(-5).ToString("dd/MM/yyyy", cul);
                txtThukyDen.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

                chkGiaiquyetdon.Checked= true;
                chkThanhvien .Checked= chkGiaiquyetvuviec.Checked = chkThuky.Checked = false;
                txtGQVVTu.Enabled = txtGQVVDen.Enabled = txtTVXXTu.Enabled = txtTVXXDen.Enabled = txtThukyTu.Enabled = txtThukyDen.Enabled = false;
                LoadCanbo(ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
               
                //}
                //catch (Exception exx) { }
            }
        }
        protected void LoadDSHoso()
        {
            decimal ChanhAnID = Convert.ToDecimal(hddCA_ID.Value);
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            PCTP_BL oPCBL = new PCTP_BL();
            decimal vIsSoTham = chkSoTham.Checked ? 1 : 0;
            decimal vIsPhucTham = chkPhucTham.Checked ? 1 : 0;
            decimal vIsGQD = chkGiaiquyetdon.Checked ? 1 : 0;
            decimal vIsGQVV = chkGiaiquyetvuviec.Checked ? 1 : 0;
            decimal vIsTVHDXX = chkThanhvien.Checked ? 1 : 0;
            decimal vIsThuKy = chkThuky.Checked ? 1 : 0;
            DateTime dFrom, dTo;
            if (chkGiaiquyetdon.Checked)
            {
                dFrom = DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dTo = DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                rptGQD.DataSource = oPCBL.PCTP_TPGQD_CHUAPHANCONG(ToaAnID, DateTime.Now, ChanhAnID, dFrom, dTo);
                rptGQD.DataBind();
            }
            else
            {
                if (hddLoaiToa.Value == "CAPHUYEN")
                {

                }
                else
                {
                   
                    //rptCapTinh.DataSource = oPCBL.PCTP_T_GETLIST(ToaAnID, DateTime.Now, ChanhAnID, DateTime.Now, DateTime.Now.AddDays(-5), vIsSoTham, vIsPhucTham, vIsGQD, vIsGQVV, vIsTVHDXX, vIsThuKy);
                    //rptCapTinh.DataBind();
                }
            }
        }
        protected void LoadCanbo(string strMaChucdanh)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            PCTP_BL oBL = new PCTP_BL();
            rptCanbo.DataSource = oBL.PCTP_CANBO_GETBYDONVI(ToaAnID, strMaChucdanh);
            rptCanbo.DataBind();
        }
        protected void chkSoTham_CheckedChanged(object sender, EventArgs e)
        {
            if(chkSoTham.Checked)
            {
                chkGiaiquyetdon.Checked = true; chkGiaiquyetdon.Enabled = txtTuNgay.Enabled = txtDenNgay.Enabled = true;
            }
            else
            {
                chkGiaiquyetdon.Checked = false; chkGiaiquyetdon.Enabled = txtTuNgay.Enabled = txtDenNgay.Enabled = false;
            }
        }

        protected void chkPhucTham_CheckedChanged(object sender, EventArgs e)
        {
            if(chkPhucTham.Checked)
            {
                chkThanhvien.Checked = chkThanhvien.Enabled = chkThanhvien.Enabled = txtTVXXTu.Enabled = txtTVXXDen.Enabled = true;
            }
            else
            {
                chkThanhvien.Checked = chkThanhvien.Enabled = chkThanhvien.Enabled = txtTVXXTu.Enabled = txtTVXXDen.Enabled = false;
            }
        }

        protected void chkGiaiquyetdon_CheckedChanged(object sender, EventArgs e)
        {
            txtTuNgay.Enabled = txtDenNgay.Enabled = chkGiaiquyetdon.Checked;
                            
            if(chkGiaiquyetdon.Checked)
            {
                chkGiaiquyetvuviec.Checked = chkThanhvien.Checked = chkThuky.Checked = false;
                LoadCanbo( ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                txtGQVVTu.Enabled = txtGQVVDen.Enabled = txtTVXXTu.Enabled = txtTVXXDen.Enabled = txtThukyTu.Enabled = txtThukyDen.Enabled = false;
            }
           
        }

        protected void chkGiaiquyetvuviec_CheckedChanged(object sender, EventArgs e)
        {
            txtGQVVTu.Enabled = txtGQVVDen.Enabled = chkGiaiquyetvuviec.Checked;
            if (chkGiaiquyetvuviec.Checked)
            {
                chkGiaiquyetdon.Checked = chkThanhvien.Checked = chkThuky.Checked = false;
                LoadCanbo( ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                txtTuNgay.Enabled = txtDenNgay.Enabled = txtTVXXTu.Enabled = txtTVXXDen.Enabled = txtThukyTu.Enabled = txtThukyDen.Enabled = false;
            }
            
        }

        protected void chkThanhvien_CheckedChanged(object sender, EventArgs e)
        {
            txtTVXXTu.Enabled = txtTVXXDen.Enabled = chkThanhvien.Checked;
            if (chkThanhvien.Checked)
            {
                chkGiaiquyetdon.Checked = chkGiaiquyetvuviec.Checked = chkThuky.Checked = false;
                LoadCanbo( ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                txtTuNgay.Enabled = txtDenNgay.Enabled = txtGQVVTu.Enabled = txtGQVVDen.Enabled =  txtThukyTu.Enabled = txtThukyDen.Enabled = false;
            }
            
        }

        protected void chkThuky_CheckedChanged(object sender, EventArgs e)
        {
             txtThukyTu.Enabled = txtThukyDen.Enabled = chkThuky.Checked;
            if (chkThuky.Checked)
            {
                chkGiaiquyetdon.Checked = chkGiaiquyetvuviec.Checked = chkThanhvien.Checked = false;
                LoadCanbo( ENUM_CHUCDANH.CHUCDANH_THUKY);
                txtTuNgay.Enabled = txtDenNgay.Enabled = txtGQVVTu.Enabled = txtGQVVDen.Enabled = txtTVXXTu.Enabled = txtTVXXDen.Enabled =  false;
            }
         
        }

        protected void cmdTraCuu_Click(object sender, EventArgs e)
        {
            LoadDSHoso();
            hddKetquaID.Value = "";
           cmdPrint.Visible = false;
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            decimal ChanhAnID = Convert.ToDecimal(hddCA_ID.Value);
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            PCTP_BL oPCBL = new PCTP_BL();
            decimal vIsSoTham = chkSoTham.Checked ? 1 : 0;
            decimal vIsPhucTham = chkPhucTham.Checked ? 1 : 0;
            decimal vIsGQD = chkGiaiquyetdon.Checked ? 1 : 0;
            decimal vIsGQVV = chkGiaiquyetvuviec.Checked ? 1 : 0;
            decimal vIsTVHDXX = chkThanhvien.Checked ? 1 : 0;
            decimal vIsThuKy = chkThuky.Checked ? 1 : 0;
            DateTime dFrom, dTo;
            if (chkGiaiquyetdon.Checked)
            {
                dFrom = DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dTo = DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
             decimal IDKETQUA=   oPCBL.PCTP_TPGQD_PHANCONGNGAUNHIEN(ToaAnID, DateTime.Now, ChanhAnID,Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), dFrom, dTo,ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (IDKETQUA > 0)
                {
                    cmdPrint.Visible = true;
                    hddKetquaID.Value = IDKETQUA.ToString();
                    lblThongbao.Text = "Hoàn thành phân công ngẫu nhiên !";
                    rptGQD.DataSource = oPCBL.PCTP_TPGQD_DAPHANCONG(ToaAnID, IDKETQUA);
                    rptGQD.DataBind();
                }
                else
                    lblThongbao.Text = "Lỗi trong quá trình phân công !";
            }
        }
    }
}