
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.DonKK;

namespace WEB.GSTP.QTDKK.DSTaikhoanND
{
    public partial class Capnhat : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int ROOT = 0;
        public int CurrYear = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrYear = DateTime.Now.Year;
            try
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    if (Request["tk"] != null)
                    {
                        decimal tkID = Convert.ToDecimal(Request["tk"].ToString());
                        hddCurrID.Value = tkID.ToString();
                        LoadTaiKhoanInfo(tkID);
                        Disable_Thongtin(tkID);
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadTaiKhoanInfo(decimal tkID)
        {
            td_mk.Visible = false;
            hddmatkhau.Value = "1";
            DONKK_USERS dmTaiKhoan = dt.DONKK_USERS.Where(x => x.ID == tkID).FirstOrDefault<DONKK_USERS>();
            if (dmTaiKhoan != null)
            {
                string mucdichsd = (string.IsNullOrEmpty(dmTaiKhoan.MUCDICH_SD + "")) ? "1" : dmTaiKhoan.MUCDICH_SD.ToString();
                if (mucdichsd == "0")
                    mucdichsd = "2";
                rdMucDichSD.SelectedValue = mucdichsd;

                //thong tin tai khoan
                txtEMAIL.Text = dmTaiKhoan.EMAIL;
                txtPASSWORD.Text = dmTaiKhoan.PASSWORD;
                //dropREMINDERQUERYQUESTION.Text = dmTaiKhoan.REMINDERQUERYQUESTION;
                //txtREMINDERQUERYANSWER.Text = dmTaiKhoan.REMINDERQUERYANSWER;
                radUSERTYPE.SelectedValue = dmTaiKhoan.USERTYPE!=null? dmTaiKhoan.USERTYPE.ToString():"-1";

                //thong tin doanh nghiep
                txtDN_MASOTHUE.Text = dmTaiKhoan.DN_MASOTHUE;
                txtDN_TENVN.Text = dmTaiKhoan.DN_TENVN;
                txtDN_TENEN.Text = dmTaiKhoan.DN_TENEN;
                txtDN_GPDKKD.Text = dmTaiKhoan.DN_GPDKKD;

                //Nguoi dai dien
                txtNDD_HOTEN.Text = dmTaiKhoan.NDD_HOTEN;
                dropNDD_GIOITINH.SelectedValue = dmTaiKhoan.NDD_GIOITINH != null ? dmTaiKhoan.NDD_GIOITINH.ToString() : "-1";
                txtNDD_NGAYSINH.Text = dmTaiKhoan.NDD_NGAYSINH!=null?((DateTime)dmTaiKhoan.NDD_NGAYSINH).ToString("dd/MM/yyyy", cul):"";
                txtNamSinh.Text = dmTaiKhoan.NDD_NAMSINH + "";
                dropQuocTich.SelectedValue = dmTaiKhoan.NDD_QUOCTICH + "";
                txtNDD_CMND.Text = dmTaiKhoan.NDD_CMND;
                txtNDD_NGAYCAP.Text = dmTaiKhoan.NDD_NGAYCAP!=null?((DateTime)dmTaiKhoan.NDD_NGAYCAP).ToString("dd/MM/yyyy", cul):"";
                txtNDD_NOICAP.Text = dmTaiKhoan.NDD_NOICAP;
                dropTinh.SelectedValue = dmTaiKhoan.DIACHI_TINH_ID + "";
                dropQuan.SelectedValue = dmTaiKhoan.DIACHI_HUYEN_ID + "";
                txtDIACHI_CHITIET.Text = dmTaiKhoan.DIACHI_CHITIET;
                txtTELEPHONE.Text = dmTaiKhoan.TELEPHONE;
                txtMOBILE.Text = dmTaiKhoan.MOBILE;

               
            }
        }
        void Disable_Thongtin(Decimal userid)
        {
            DataTable oDT = null;
            DONKK_DON_BL obj = new DONKK_DON_BL();
            oDT = obj.GetYeuCauThayDoi(userid);
            if (oDT.Rows.Count == 0)
            {
                rdMucDichSD.Enabled = false;
                cmdUpdate.Enabled = false;
            }
                

            txtNDD_HOTEN.Enabled = dropNDD_GIOITINH.Enabled = txtNDD_NGAYSINH.Enabled = txtNamSinh.Enabled = dropQuocTich.Enabled=  false;
            txtNDD_CMND.Enabled = txtNDD_NGAYCAP.Enabled = txtNDD_NOICAP.Enabled = dropTinh.Enabled = dropQuan.Enabled = txtDIACHI_CHITIET.Enabled = false;
            txtMOBILE.Enabled = txtTELEPHONE.Enabled = false;
           
            //thong tin tai khoan
            txtEMAIL.Enabled =  txtPASSWORD.Enabled = false;
            radUSERTYPE.Enabled = false;
            //thong tin doanh nghiep
            txtDN_MASOTHUE.Enabled = txtDN_TENVN.Enabled = txtDN_TENEN.Enabled = txtDN_GPDKKD.Enabled = false;

        }
        void LoadDrop()
        {
            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            //-------------------------
            LoadDropTinh(dropTinh, true);
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTinh.SelectedValue), dropQuan, true);
            }
            catch (Exception ex) { }
        }
        void LoadDropTinh(DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(0);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                }
            }
        }
        void LoadDMHanhChinhByParentID(Decimal ParentID, DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            if (ShowChangeAll)
                    drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (ParentID > 0)
            {                
                DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                DataTable tbl = obj.GetAllByParentID(ParentID);                
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                        drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                }
            }
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);

            drop.Items.Clear();
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        protected void dropTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTinh.SelectedValue), dropQuan, true);
            }
            catch (Exception ex) { }
            Cls_Comon.SetFocus(this, this.GetType(), dropQuan.ClientID);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DONKK_USERS obj = new DONKK_USERS();
            int CurrID = 0;
            string email = txtEMAIL.Text;
            CurrID = (String.IsNullOrEmpty(hddCurrID.Value))? 0: Convert.ToInt32(hddCurrID.Value);
            try
            {
                if (CurrID>0)                    
                    obj = dt.DONKK_USERS.Where(x => x.ID == CurrID).FirstOrDefault<DONKK_USERS>();                
            }
            catch (Exception ex)
            {
                obj = new DONKK_USERS();
            }

            obj.MUCDICH_SD = Convert.ToInt16(rdMucDichSD.SelectedValue);

            //Thong tin tai khoan
            obj.EMAIL = txtEMAIL.Text.Trim();
            //obj.REMINDERQUERYQUESTION = dropREMINDERQUERYQUESTION.Text;
            //obj.REMINDERQUERYANSWER = txtREMINDERQUERYANSWER.Text;
            obj.USERTYPE = Convert.ToInt32(radUSERTYPE.SelectedValue);

            //Thong tin doanh ngiep
            obj.DN_MASOTHUE = "";
            obj.DN_TENVN = "";
            obj.DN_TENEN = "";
            obj.DN_GPDKKD = "";
            if (radUSERTYPE.SelectedValue == "2")
            {
                obj.DN_MASOTHUE = txtDN_MASOTHUE.Text.Trim();
                obj.DN_TENVN = txtDN_TENVN.Text.Trim();
                obj.DN_TENEN = txtDN_TENEN.Text.Trim();
                obj.DN_GPDKKD = txtDN_GPDKKD.Text.Trim();
            }
            if (radUSERTYPE.SelectedValue == "3")
            {
                obj.DN_TENVN = txtDN_TENVN.Text.Trim();
                obj.DN_TENEN = txtDN_TENEN.Text.Trim();
            }

            //Nguoi dai dien
            obj.NDD_HOTEN = txtNDD_HOTEN.Text.Trim();
            if (dropNDD_GIOITINH.SelectedValue != "")
                obj.NDD_GIOITINH = Convert.ToInt32(dropNDD_GIOITINH.SelectedValue);
            if (txtNDD_NGAYSINH.Text.Trim() != "")
                obj.NDD_NGAYSINH = DateTime.Parse(txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NDD_NAMSINH= Convert.ToInt32(txtNamSinh.Text.Trim());
            obj.NDD_QUOCTICH=Convert.ToInt32(dropQuocTich.SelectedValue);
            obj.NDD_CMND = txtNDD_CMND.Text.Trim();
            if (txtNDD_NGAYCAP.Text.Trim() != "")
                obj.NDD_NGAYCAP = DateTime.Parse(txtNDD_NGAYCAP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NDD_NOICAP = txtNDD_NOICAP.Text.Trim();
            obj.DIACHI_TINH_ID=Convert.ToInt32(dropTinh.SelectedValue);
            obj.DIACHI_HUYEN_ID = Convert.ToInt32(dropQuan.SelectedValue);
            obj.DIACHI_CHITIET = txtDIACHI_CHITIET.Text.Trim();
            obj.TELEPHONE = txtTELEPHONE.Text.Trim();
            obj.MOBILE = txtMOBILE.Text.Trim();

            String Pass = "";
            if (CurrID == 0)
            {
                List<DONKK_USERS> lst = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower().Contains(email.ToLower())).ToList<DONKK_USERS>();
                if (lst != null && lst.Count > 0)
                {
                    lbthongbao.Text = "Tài khoản này đã tồn tại, hãy kiểm tra lại.";
                    txtEMAIL.Focus();
                    return;
                }
                Pass = txtPASSWORD.Text.Trim();
                obj.PASSWORD = Cls_Comon.MD5Encrypt(Pass);
                obj.CREATEDATE = DateTime.Now;
                obj.MODIFIEDDATE = DateTime.Now;
                obj.ACTIVATIONCODE = Guid.NewGuid().ToString();

                obj.STATUS = 2;
                dt.DONKK_USERS.Add(obj);

                //String LinkActive = Cls_Comon.GetRootURL() + "/ActiveTK.aspx?uid=" + Cls_Comon.MD5Encrypt(obj.ID.ToString()) + "&ucode=" + Cls_Comon.MD5Encrypt(obj.ACTIVATIONCODE);
                Module.Common.Cls_SendMail.SendDangKyTK(obj.EMAIL, obj.NDD_HOTEN, txtEMAIL.Text.Trim(), Pass);
            }
            else
            {
                List<DONKK_USERS> lst = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower().Contains(email.ToLower())).ToList<DONKK_USERS>();
               
                if (lst != null && lst.Count > 0)
                {
                    obj = lst[0];
                    if (obj.ID != CurrID)
                    {
                        lbthongbao.Text = "Tài khoản này đã tồn tại, hãy kiểm tra lại.";
                        txtEMAIL.Focus();
                        return;
                    }
                }
                obj.MODIFIEDDATE = DateTime.Now;
            }
            dt.SaveChanges();
            lbthongbao.Text = "Cập nhật thành công!";
            Response.Redirect("Danhsach.aspx");
        }
        Boolean CheckExistEmail(string temp_email, decimal user_id)
        {
            string email = temp_email.ToLower();
            /*-----KT: Chu ky so da duoc dk hay chua*/
            try
            {
                DONKK_USERS objUser = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower() == email && x.ID != user_id).Single<DONKK_USERS>();
                if (objUser != null)
                {
                    lbthongbao.Text = "Địa chỉ email này đã được dùng đăng ký tài khoản trong hệ thống. Đề nghị kiểm tra lại!";
                    return true;
                }
                else return false;
            }
            catch (Exception ex) { return false; }
        }
        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        protected void radUSERTYPE_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (radUSERTYPE.SelectedValue=="1")
            {
                lblThongTin.Text = "Thông tin cá nhân";
                plDoanhNghiep.Visible = false;
            }
            if (radUSERTYPE.SelectedValue == "2")
            {
                lblThongTin.Text = "Người đại diện";
                lblthongtinDN.Text = "Thông tin doanh nghiệp";
                plDoanhNghiep.Visible = true;
                pnlttDN.Visible = true;
            }
            if (radUSERTYPE.SelectedValue == "3")
            {
                lblThongTin.Text = "Người đại diện";
                lblthongtinDN.Text = "Thông tin tổ chức";
                plDoanhNghiep.Visible = true;
                pnlttDN.Visible = false;
            }

        }
        protected void txtNDD_NGAYSINH_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNDD_NGAYSINH.Text))
            {
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNDD_NGAYSINH.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_temp != DateTime.MinValue)
                {
                    txtNamSinh.Text = date_temp.Year + "";
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtNamSinh.ClientID);
        }
    }
}