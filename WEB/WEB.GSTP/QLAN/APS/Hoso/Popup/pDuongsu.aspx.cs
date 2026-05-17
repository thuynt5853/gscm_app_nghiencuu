using BL.GSTP;
using BL.GSTP.APS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.APS.Hoso.Popup
{
    public partial class pDuongsu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0,DuongSuID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCombobox();
                DonID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                DuongSuID = (String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");
                if (DuongSuID > 0)
                {
                    loadedit(DuongSuID);
                }
                else
                {
                    //thêm mới
                    ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                    chkBoxCMNDND.Checked = false;
                }
                hddid.Value = DuongSuID.ToString();
                if (hddid.Value == "" || hddid.Value == "0") SetTinhHuyenMacDinh();
                CheckQuyen(DonID);
                LoadInfo();
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
            }
        }

        private void LoadInfo()
        {
           
            var ddlTuCach = ddlTucachTotung.SelectedValue;
            if (ddlTuCach == "NGUOIYEUCAUPS")
            {
                lbDuongSu.Text = "Đối tượng yêu cầu<span class='batbuoc'>(*)</span>";
                lbDuongSu.Visible = true;
                lbTenDuongSu.Text = "Người yêu cầu<span class='batbuoc'>(*)</span>";
                lbTenDuongSu.Visible = true;
                ddlLoaiNguyendon.Visible = true;
                pnLoaiHinhDoanhNghiep.Visible = false;
                pnNDTochuc.Visible = true;
                ltCMNDND.Visible = true;
                pnNDCanhan.Visible = false;
                pnLienHe.Visible = true;
                pnCuTru.Visible = true;
                lbLoadDuongSu.Visible = false;
            }
            else if (ddlTuCach == "DNHTXBITUYENBOPS")
            {
                lbDuongSu.Text = "Đối tượng yêu cầu<span class='batbuoc'>(*)</span>";
                lbDuongSu.Visible = false;
                lbTenDuongSu.Text = "Đối tượng bị yêu cầu<span class='batbuoc'>(*)</span>";
                pnLoaiHinhDoanhNghiep.Visible = true;
                ddlLoaiNguyendon.Visible = false;
                lbTenDuongSu.Visible = true;
                pnNDTochuc.Visible = true;
                ltCMNDND.Visible = true;
                pnNDCanhan.Visible = false;
                pnLienHe.Visible = true;
                pnCuTru.Visible = true;
                lbLoadDuongSu.Visible = false;
            }
            else
            {
                lbTenDuongSu.Text = "Tên đương sự <span class='batbuoc'>(*)</span>";
                pnLoaiHinhDoanhNghiep.Visible = false;
                lbDuongSu.Visible = false;
                ddlLoaiNguyendon.Visible = false;
                lbTenDuongSu.Visible = true;
                ltCMNDND.Visible = true;
                pnLienHe.Visible = true;
                pnCuTru.Visible = true;
                lbLoadDuongSu.Visible = true;
                if (ddlDuongSu.SelectedValue == "1")
                {
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;

                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                }
      
            }
            //decimal IDLOAIBD = Convert.ToDecimal(ddlLoaiHinh.SelectedValue);
            //DM_QHPL_TK oItemBD = dt.DM_QHPL_TK.Where(x => x.ID == IDLOAIBD).FirstOrDefault();
            //if ((oItemBD.ARRSAPXEP + "/").Contains("0/401/"))
            //{
            //    lstNganhKT.Visible = true;
            //    ddlNganhKT.Visible = true;
            //    if (oBD.NGANHKINHTEID != null) ddlNganhKT.SelectedValue = oBD.NGANHKINHTEID.ToString();
            //}
            //else
            //{
            //    lstNganhKT.Visible = false;
            //    ddlNganhKT.Visible = false;
            //}
   
        }
        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
        }
        private void SetTinhHuyenMacDinh()
        {
            //Set defaul value Tinh/Huyen dua theo tai khoan dang nhap
            Cls_Comon.SetValueComboBox(ddlNoiSongTinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropNoiSongHuyen();
            Cls_Comon.SetValueComboBox(ddlNoiSongHuyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

            Cls_Comon.SetValueComboBox(ddl_NDD_Tinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDrop_NDD_Huyen();
            Cls_Comon.SetValueComboBox(ddl_NDD_Huyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

        }
        private void LoadLoaiND(bool flag)
        {
            ddlLoaiNguyendon.Items.Clear();
            if (flag)
            {
                DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
                //Load đối tượng nộp đơn
                ddlLoaiNguyendon.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.DOITUONGNOPYCPS);
                ddlLoaiNguyendon.DataTextField = "TEN";
                ddlLoaiNguyendon.DataValueField = "ID";
                ddlLoaiNguyendon.DataBind();
            }
        
        }
        protected void chkBoxCMNDND_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDND.Checked)
            {
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDND.Text = "";
            }

        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();
            ddlTucachTotung.Items.Clear();
            ddlTucachTotung.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNGPS);
            ddlTucachTotung.DataTextField = "TEN";
            ddlTucachTotung.DataValueField = "MA";
            ddlTucachTotung.DataBind();
            //Loại hình doanh nghiệp
            ddlLoaiHinh.Items.Clear();
            ddlLoaiHinh.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN).OrderBy(y => y.ARRTHUTU).ToList();
            ddlLoaiHinh.DataTextField = "CASE_NAME";
            ddlLoaiHinh.DataValueField = "ID";
            ddlLoaiHinh.DataBind();
            //Ngành kinh tế 
            ddlNganhKT.Items.Clear();
            ddlNganhKT.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.NGANHKINHTE).OrderBy(y => y.ARRTHUTU).ToList();
            ddlNganhKT.DataTextField = "CASE_NAME";
            ddlNganhKT.DataValueField = "ID";
            ddlNganhKT.DataBind();
            LoadLoaiND(true);


            LoadDropTinh();
        }
        private bool CheckValid()
        {
            if (txtTennguyendon.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên đương sự";
                return false;
            }
      
            if (!chkBoxCMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtND_CMND.Text))
                {
                    lbthongbao.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                    txtND_CMND.Focus();
                    return false;
                }

            }

            return true;
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {

                txtND_Namsinh.Text = d.Year.ToString();
                
            }
            txtND_Namsinh.Focus();
        }
        protected void ddlDuongSu_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlDuongSu.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
         
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlTucachTotung.ClientID);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";

                DonID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");

                APS_DON_DUONGSU oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new APS_DON_DUONGSU();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.APS_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DonID;
                oND.DIACHICOQUAN = txt_NoiLamViec.Text.Trim();
                oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                oND.ISDAIDIEN = 0;
                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                if (ddlTucachTotung.SelectedValue == "NGUOIYEUCAUPS" )
                {

                    oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                }
                else if(ddlTucachTotung.SelectedValue == "NGUOICOQLNVLQPS")
                {
                    oND.LOAIDUONGSU = Convert.ToDecimal(ddlDuongSu.SelectedValue);
                }else
                {
               
                    oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiHinh.SelectedValue);
                    if (ddlNganhKT.Visible)
                        oND.NGANHKINHTEID = Convert.ToDecimal(ddlNganhKT.SelectedValue);
                    else
                        oND.NGANHKINHTEID = 0;
                }
                
                oND.SOCMND = txtND_CMND.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                
                //oND.HKTTTINHID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
                //oND.HKTTID = Convert.ToDecimal(ddlThuongTruHuyen.SelectedValue);
                //oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                if (ddlNganhKT.Visible)
                    oND.NGANHKINHTEID = Convert.ToDecimal(ddlNganhKT.SelectedValue);
                else
                    oND.NGANHKINHTEID = 0;
                oND.TAMTRUTINHID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
                oND.TAMTRUID = Convert.ToDecimal(ddlNoiSongHuyen.SelectedValue);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = 0;
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                oND.CHUCVU = txtND_NDD_Chucvu.Text;
                oND.EMAIL = txtEmail.Text;
                oND.DIENTHOAI = txtDienthoai.Text;
                oND.SINHSONG_NUOCNGOAI = chkONuocNgoai.Checked == true ? 1 : 0;
                oND.FAX = txtFax.Text;
                if (pnNDTochuc.Visible)
                {
                    oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                    if (ddl_NDD_Huyen.SelectedValue != "0")
                    {
                        oND.NDD_DIACHIID = Convert.ToDecimal(ddl_NDD_Huyen.SelectedValue);
                    }
                    oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                }
                oND.ISDON = 1;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.SaveChanges();
                }
                lbthongbao.Text = "Lưu thành công!";
                APS_DON_DUONGSU_BL oDonBL = new APS_DON_DUONGSU_BL();
                oDonBL.APS_DON_YEUTONUOCNGOAI_UPDATE(DonID);

                Resetcontrols();
                //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UpdateRefesh", " window.opener.location.reload();window.close();", true);

            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        private void Resetcontrols()
        {
            hddid.Value = "0";
            ddlLoaiHinh.SelectedIndex = 0;
            txtTennguyendon.Text = txtND_NDD_Ten.Text = txtND_NDD_Chucvu.Text = txtND_CMND.Text = txtND_Ngaysinh.Text = "";
            txtND_NDD_Diachichitiet.Text = txtND_Namsinh.Text = txtND_TTChitiet.Text = txt_NoiLamViec.Text = txtEmail.Text = txtDienthoai.Text = txtFax.Text = "";

        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            APS_DON_DUONGSU oND = dt.APS_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            txtTennguyendon.Text = oND.TENDUONGSU;
            //LoadInfo();
            if (string.IsNullOrEmpty(oND.SOCMND))
            {
                ltCMNDND.Text = "";
                chkBoxCMNDND.Checked = true;
            }
            else
            {
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                chkBoxCMNDND.Checked = false;
            }
            txtND_CMND.Text = oND.SOCMND;
            ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;
            txt_NoiLamViec.Text = oND.DIACHICOQUAN + "";
      

            if (ddlTucachTotung.SelectedValue == "NGUOIYEUCAUPS")
            {
                ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
                LoadLoaiND(true);
            }
            else if (ddlTucachTotung.SelectedValue == "NGUOICOQLNVLQPS")
            {
                ddlDuongSu.SelectedValue = oND.LOAIDUONGSU.ToString();
            }
            else
            {
                ddlLoaiHinh.SelectedValue = oND.LOAIDUONGSU.ToString();
             
            }
            //if (oND.HKTTTINHID != null)
            //{
            //    ddlThuongTruTinh.SelectedValue = oND.HKTTTINHID.ToString();
            //    LoadDropThuongTruHuyen();
            //    if (oND.HKTTID != null) ddlThuongTruHuyen.SelectedValue = oND.HKTTID.ToString();
            //}
            if (oND.TAMTRUTINHID != null)
            {
                ddlNoiSongTinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                LoadDropNoiSongHuyen();
                if (oND.TAMTRUID != null) ddlNoiSongHuyen.SelectedValue = oND.TAMTRUID.ToString();
            }
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            if (ddlNganhKT.Visible)

                ddlNganhKT.SelectedValue = oND.NGANHKINHTEID.ToString();
            else
                oND.NGANHKINHTEID = 0;
            //txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
            if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);

            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
            txtND_NDD_Chucvu.Text = oND.CHUCVU;
          
                txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                txtND_NDD_Chucvu.Text = oND.CHUCVU;
                if (oND.NDD_DIACHIID != null)
                {
                    DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (hc != null)
                    {
                        ddl_NDD_Tinh.SelectedValue = hc.CAPCHAID.ToString();
                        LoadDrop_NDD_Huyen();
                        ddl_NDD_Huyen.SelectedValue = hc.ID.ToString();
                    }
                }
                txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
            

            //oND.NDD_DIACHIID = Convert.ToDecimal(ddl_NDD_Huyen.SelectedValue);
            //    oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
            
            //oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
            if (ddlDuongSu.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            if (oND.SINHSONG_NUOCNGOAI != null) chkONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                chkONuocNgoai.Visible = false;
            }
            else
            {
                chkONuocNgoai.Visible = true;
            }
            txtEmail.Text = oND.EMAIL + "";
            txtDienthoai.Text = oND.DIENTHOAI + "";
            txtFax.Text = oND.FAX;
          
            if (oND.ISDAIDIEN == 1)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                lbthongbao.Text = "Bạn không được sửa nguyên đơn hoặc bị đơn đại diện!";
                return;
            }
            else
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                chkONuocNgoai.Visible = false;
            }
            else
            {
                chkONuocNgoai.Visible = true;
            }
            decimal ID = Convert.ToDecimal(ddlDuongSu.SelectedValue);
            DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == ID).FirstOrDefault();
            if (oItem.MA == ENUM_DOITUONG_NOPYCPS.NGUOILAODONG)
                Cls_Comon.SetFocus(this, this.GetType(), ddlND_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtEmail.ClientID);
        }
        protected void chkONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongTinh.ClientID);
        }
        private void LoadDropTinh()
        {
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                //ddlThuongTruTinh.DataSource = lstTinh;
                //ddlThuongTruTinh.DataTextField = "TEN";
                //ddlThuongTruTinh.DataValueField = "ID";
                //ddlThuongTruTinh.DataBind();

                ddlNoiSongTinh.DataSource = lstTinh;
                ddlNoiSongTinh.DataTextField = "TEN";
                ddlNoiSongTinh.DataValueField = "ID";
                ddlNoiSongTinh.DataBind();

                ddl_NDD_Tinh.DataSource = lstTinh;
                ddl_NDD_Tinh.DataTextField = "TEN";
                ddl_NDD_Tinh.DataValueField = "ID";
                ddl_NDD_Tinh.DataBind();
                //ddlThuongTruTinh.Items.Insert(0,new ListItem("---Chọn---", "0"));
                ddlNoiSongTinh.Items.Insert(0,new ListItem("---Chọn---", "0"));
                ddl_NDD_Tinh.Items.Insert(0,new ListItem("---Chọn---", "0"));
            }
            else
            {
               // ddlThuongTruTinh.Items.Add(new ListItem("---Chọn---", "0"));
                ddlNoiSongTinh.Items.Add(new ListItem("---Chọn---", "0"));
                ddl_NDD_Tinh.Items.Add(new ListItem("---Chọn---", "0"));
            }
            //LoadDropThuongTruHuyen();
            LoadDropNoiSongHuyen();
            LoadDrop_NDD_Huyen();
        }
        private void LoadDropNoiSongHuyen()
        {
            ddlNoiSongHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNoiSongHuyen.DataSource = lstHuyen;
                ddlNoiSongHuyen.DataTextField = "TEN";
                ddlNoiSongHuyen.DataValueField = "ID";
                ddlNoiSongHuyen.DataBind();
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
            else
            {
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
        }
        private void LoadDrop_NDD_Huyen()
        {
            ddl_NDD_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddl_NDD_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddl_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddl_NDD_Huyen.DataSource = lstHuyen;
                ddl_NDD_Huyen.DataTextField = "TEN";
                ddl_NDD_Huyen.DataValueField = "ID";
                ddl_NDD_Huyen.DataBind();
                ddl_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
            else
            {
                ddl_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
        }
        //protected void ddlThuongTruTinh_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDropThuongTruHuyen();
        //        Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTruHuyen.ClientID);
        //    }
        //    catch (Exception ex) { lbthongbao.Text = ex.Message; }
        //}
        protected void ddlNoiSongTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNoiSongHuyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongHuyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void ddlTucachTotung_SelectedIndexChanged(object sender, EventArgs e)
        {
            var ddlTuCach = ddlTucachTotung.SelectedValue;
            if (ddlTuCach == "NGUOIYEUCAUPS")
            {
                lbDuongSu.Text = "Đối tượng yêu cầu<span class='batbuoc'>(*)</span>";
                lbDuongSu.Visible = true;
                lbTenDuongSu.Text = "Người yêu cầu<span class='batbuoc'>(*)</span>";
                lbTenDuongSu.Visible = true;
                ddlLoaiNguyendon.Visible = true;
                pnLoaiHinhDoanhNghiep.Visible = false;
                pnNDTochuc.Visible = true;
                ltCMNDND.Visible = true;
                pnNDCanhan.Visible = false;
                pnLienHe.Visible = true;
                pnCuTru.Visible = true;
                lbLoadDuongSu.Visible = false;
            }
            else if (ddlTuCach == "DNHTXBITUYENBOPS")
            {
                lbDuongSu.Text = "Đối tượng yêu cầu<span class='batbuoc'>(*)</span>";
                lbDuongSu.Visible = false;
                lbTenDuongSu.Text = "Đối tượng bị yêu cầu<span class='batbuoc'>(*)</span>";
                pnLoaiHinhDoanhNghiep.Visible = true;
                ddlLoaiNguyendon.Visible = false;
                lbTenDuongSu.Visible = true;
                pnNDTochuc.Visible = true;
                ltCMNDND.Visible = true;
                pnNDCanhan.Visible = false;
                pnLienHe.Visible = true;
                pnCuTru.Visible = true;
                lbLoadDuongSu.Visible = false;
            }
            else
            {
          
                lbTenDuongSu.Text = "Tên đương sự <span class='batbuoc'>(*)</span>";
                pnLoaiHinhDoanhNghiep.Visible = false;
                lbDuongSu.Visible = false;
                ddlLoaiNguyendon.Visible = false;
                lbTenDuongSu.Visible = true;
                ltCMNDND.Visible = true;
                pnLienHe.Visible = true;
                pnCuTru.Visible = true;
                lbLoadDuongSu.Visible = true;
                if (ddlDuongSu.SelectedValue == "1")
                {
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;

                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                }
            }
            LoadLoaiND(true);
            Cls_Comon.SetFocus(this, this.GetType(), ddlLoaiNguyendon.ClientID);
        }

        protected void ddlLoaiHinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlLoaiHinh.SelectedValue);
            DM_QHPL_TK oItem = dt.DM_QHPL_TK.Where(x => x.ID == ID).FirstOrDefault();
            if ((oItem.ARRSAPXEP + "/").Contains("0/401/"))
            {
                lstNganhKT.Visible = true;
                ddlNganhKT.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), ddlNganhKT.ClientID);
            }
            else
            {
                lstNganhKT.Visible = false;
                ddlNganhKT.Visible = false;
            }
        }

        protected void ddl_NDD_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDrop_NDD_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddl_NDD_Huyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
    }
}