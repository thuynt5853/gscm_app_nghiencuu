using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pRutKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    txtNgayTaoPhieu.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    //GetNewSoPhieu();

                    if (VuAnID > 0)
                    {
                        try
                        {
                            LoadThongTinVuAn(VuAnID);
                        }
                        catch (Exception exx) { }
                    }
                }
            }
        }

        void LoadThongTinVuAn(Decimal VuAnID)
        {
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
                else
                {
                    txtTenVuan.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                }

                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                if (oT.BAQD_CAPXETXU == 4)
                {
                    txtVuAn_SoBanAn.Text = oT.SO_QDGDT;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYQD + "") || (oT.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else if (oT.BAQD_CAPXETXU == 2)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANSOTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUSOTHAM + "") || (oT.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                }

                if (oT.LOAIAN == 1)
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = true;
                    pnNguyendo.Visible = pnBidon.Visible = false;
                    txtVuAn_NguyenDon.Text = oT.NGUYENDON;
                    txtVuAn_BiDon.Text = oT.BIDON;
                }
                else
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = false;
                    pnNguyendo.Visible = pnBidon.Visible = true;
                    //----------------------------------
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                }

               

                //-------------------------------
                LoadThongTin_RutKN(oT);
            }
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
       
        public void LoadThongTin_RutKN(GDTTT_VUAN obj)
        {
            try
            {
                int is_rutkn = (string.IsNullOrEmpty(obj.ISRUTKN + "")) ? 0 : (int)obj.ISRUTKN;
                rdRutKN.SelectedValue = is_rutkn.ToString();
                if (is_rutkn > 0)
                {
                    cmdXoaRutKN.Visible = pnRutKN.Visible = cmdUpdateAndNext.Visible = true;

                    txtNgayTaoPhieu.Text = (String.IsNullOrEmpty(obj.NGAYRUTKN + "") || (obj.NGAYRUTKN == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYRUTKN).ToString("dd/MM/yyyy", cul);
                    txtSoPhieu.Text = obj.SORUTKN + "";
                        txtCanBo.Text = obj.NGUOIRUTKN_HOTEN;
                }
                else
                {
                    cmdXoaRutKN.Visible = pnRutKN.Visible = cmdUpdateAndNext.Visible = false;
                    lbthongbao.Text = "Vụ án không có yêu cầu rút kháng nghị";
                }
            }
            catch (Exception ex) { }
        }
        
        protected void cmdXoaRutKN_Click(object sender, EventArgs e)
        {
            XoaRutKN();
            
        }
        void XoaRutKN()
        {
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            if (oT != null)
            {
                oT.ISRUTKN = 0;
                oT.NGUOIRUTKN_HOTEN = "";
                oT.NGUOIRUTKN_ID = 0;
                oT.SORUTKN = "";
                oT.NGAYRUTKN = null;
                oT.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;

                dt.SaveChanges();
                lbthongbao.Text = "Xóa rút kháng nghị thành công!";
                //------------------------

                ClearForm();
                pnRutKN.Visible = cmdXoaRutKN.Visible = cmdUpdateAndNext.Visible = false;
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
        }
        void ClearForm()
        {
            txtSoPhieu.Text = txtNgayTaoPhieu.Text = txtCanBo.Text = "";
            rdRutKN.SelectedValue = "0";
        }
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            try
            {
                if (rdRutKN.SelectedValue == "1")
                {
                    if (String.IsNullOrEmpty(txtCanBo.Text))
                    {
                        Cls_Comon.ShowMessage("Bạn chưa nhập tên người rút kháng nghị!");
                        txtCanBo.Focus();
                        return;
                    }
                    //------------------------
                    SaveData();
                }
                else
                {
                    XoaRutKN();
                    lbthongbao.Text = "Cập nhật dữ liệu thành công!";
                }
                hddIsReloadParent.Value = "1";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        void SaveData()
        {
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
           
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            if (obj != null)
            {
                obj.ISRUTKN = Convert.ToDecimal(rdRutKN.SelectedValue);

                DateTime date_temp = (String.IsNullOrEmpty(txtNgayTaoPhieu.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayTaoPhieu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYRUTKN = date_temp;
                obj.SORUTKN = txtSoPhieu.Text.Trim();

                obj.NGUOIRUTKN_ID = 0;
                obj.NGUOIRUTKN_HOTEN = Cls_Comon.FormatTenRieng(txtCanBo.Text.Trim());

                dt.SaveChanges();
                lbthongbao.Text = "Cập nhật thông tin rút kháng nghị thành công";
            }
            else
            {
                lbthongbao.Text = "Vụ án không tồn tại!";
            }
        }
       
        
        protected void txtNgayTaoPhieu_TextChanged(object sender, EventArgs e)
        {
            //GetNewSoPhieu();
        }
        void GetNewSoPhieu()
        {
            DateTime NgayTao = (DateTime)((String.IsNullOrEmpty(txtNgayTaoPhieu.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayTaoPhieu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuRutKN( NgayTao);
            txtSoPhieu.Text = SoCV + "";
        }

        protected void rdRutKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdRutKN.SelectedValue == "0")
            {
                pnRutKN.Visible = cmdUpdateAndNext.Visible = false;
                ClearForm();
            }
            else { pnRutKN.Visible = cmdUpdateAndNext.Visible = true; lbthongbao.Text = "";
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (oT != null)
                    txtCanBo.Text = oT.GDQ_NGUOIKY;
            }
        }
        
    }
}