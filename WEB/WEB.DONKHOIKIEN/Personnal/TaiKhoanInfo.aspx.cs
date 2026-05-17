using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using System.Globalization;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using System.Data;
using System.IO;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class TaiKhoanInfo : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        public int CurrentYear = 0;
        public decimal QuocTichVN = 0;
        public string DUOCUYQUYEN ="DUOCUYQUYEN" ;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
           // hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    lttTenLoaiTK.Text = "Thông tin cá nhân";
                    LoadDrop();
                    LoadInfo();
                    //luu thong tin code tu dich vu cong quoc gia truyen sang neu co
                    hidDVCQGCode.Value = Request["code"];
                    if(!string.IsNullOrEmpty(hidDVCQGCode.Value))
                    {
                        tabDVCQG.Visible = true;
                    }    
                }
                //-----------them doan dk cho su kien upload file ------------------
                ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
                scriptManager.RegisterPostBackControl(this.cmdUpdate);
            }
            else Response.Redirect("/Trangchu.aspx");
        }

        #region Load Drop
        void LoadDrop()
        {
            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            LoadDropByGroupName(dropNUQ_QuocTich, ENUM_DANHMUC.QUOCTICH, false);

            //-------------------------
            LoadDrop_DMHanhChinh();
            LoadDropTuCachToTung();
        }
        void LoadDropTuCachToTung()
        {
            String MaTuCachKoSD = "$TGTTDS_01$TGTTDS_02$TGTTDS_08$TGTTDS_09$";
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTuCachTT.Items.Add(new ListItem("Nguyên đơn", "NGUYENDON"));
                dropTuCachTT.Items.Add(new ListItem("Bị đơn", "BIDON"));
                dropTuCachTT.Items.Add(new ListItem("Người có quyền và NVLQ", "QUYENNVLQ"));
                dropTuCachTT.Items.Add(new ListItem("Người được ủy quyền", DUOCUYQUYEN));
                string temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = "$" + row["MA"].ToString() + "$";
                    if (!MaTuCachKoSD.Contains(temp))
                        dropTuCachTT.Items.Add(new ListItem(row["Ten"].ToString(), row["MA"].ToString()));
                }
            }
        }

        void LoadDrop_DMHanhChinh()
        {
            Decimal ParentID = 0;
            //ListItem item_root = new ListItem("------Chọn------", "0");
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(ParentID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTamTru_Tinh.DataSource = tbl;
                dropTamTru_Tinh.DataTextField = "TEN";
                dropTamTru_Tinh.DataValueField = "ID";
                dropTamTru_Tinh.DataBind();

                dropNUQ_Tinh.DataSource = tbl;
                dropNUQ_Tinh.DataTextField = "TEN";
                dropNUQ_Tinh.DataValueField = "ID";
                dropNUQ_Tinh.DataBind();
                
                dropTamTru_Tinh.Items.Insert(0, new ListItem("------Chọn------", "0"));
                dropNUQ_Tinh.Items.Insert(0, new ListItem("------Chọn------", "0"));
            }
            dropTamTru_Huyen.Items.Insert(0, new ListItem("------Chọn------", "0"));
            dropNUQ_QuanHuyen.Items.Insert(0, new ListItem("------Chọn------", "0"));
        }
        void LoadDMHanhChinhByParentID(Decimal ParentID, DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            drop.ClearSelection();
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(ParentID);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
               
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
        protected void dropTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTamTru_Tinh.SelectedValue), dropTamTru_Huyen, true);
            }
            catch (Exception ex) { }
        }
        #endregion
        void LoadInfo()
        {
            DONKK_USERS obj = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            if (obj != null )
            {
                dropTuCachTT.SelectedValue = obj.IS_DUOC_UYQUYEN + "";

                int user_type = (int)obj.USERTYPE;
                switch(user_type)
                {
                    case 1:
                        lttTenLoaiTK.Text = "Thông tin cá nhân";
                        lttLoaiTK.Text = "Cá nhân";
                        plDoanhNghiep.Visible = false;
                        pnUyQuyen.Visible = false;
                        if (dropTuCachTT.SelectedValue == DUOCUYQUYEN)
                            pnUyQuyen.Visible = true;
                        else
                            pnUyQuyen.Visible = false;
                        break;
                    case 2:
                        plDoanhNghiep.Visible = true;
                        lttTenLoaiTK.Text = "Người đại diện";
                        lttTitleDN.Text = "Thông tin doanh nghiệp";
                        lttTenDN.Text = "Tên tiếng Việt";
                        lttLoaiTK.Text = "Doanh nghiệp";
                        pnDNMaSoThue.Visible = true;
                        pnUyQuyen.Visible = false;
                        break;
                    case 3:
                        plDoanhNghiep.Visible = true;
                        lttTenDN.Text = "Tên tổ chức";
                        lttTenLoaiTK.Text = "Người đại diện";
                        lttTitleDN.Text = "Thông tin Cơ quan/ Tổ chức";
                        lttLoaiTK.Text = "Cơ quan/ Tổ chức";
                        pnDNMaSoThue.Visible = false;
                        pnEngName.Visible = false;
                        pnUyQuyen.Visible = false;
                        break;
                }

                //-----------------------------------
                rdMucDichSD.Enabled = false;
                int mucdichsd = (string.IsNullOrEmpty(obj.MUCDICH_SD + "")) ? 1 : (int)obj.MUCDICH_SD;
                rdMucDichSD.SelectedValue = mucdichsd.ToString();
                
                //-----------------------------------
                txtEMAIL.Text = obj.EMAIL;
                dropQuocTich.SelectedValue = obj.NDD_QUOCTICH.ToString();

                txtDN_MASOTHUE.Text = obj.DN_MASOTHUE;
                txtDN_TENVN.Text = obj.DN_TENVN;
                txtDN_TENEN.Text = obj.DN_TENEN;
                txtDN_GPDKKD.Text = obj.DN_GPDKKD;
                txtDN_DienThoai.Text = obj.DN_TELEPHONE;
                txtDN_DiaChi.Text = obj.DN_DIACHI;
                txtDN_othername.Text = obj.DN_TENKHAC;

                txtNDD_HOTEN.Text = obj.NDD_HOTEN;
                txtNDD_NGAYSINH.Text = obj.NDD_NGAYSINH != null ? ((DateTime)obj.NDD_NGAYSINH).ToString("dd/MM/yyyy", cul) : "";
                txtNamSinh.Text = (String.IsNullOrEmpty( obj.NDD_NAMSINH+"")) ? "0": obj.NDD_NAMSINH.ToString();

                dropQuocTich.SelectedValue = obj.NDD_QUOCTICH+"";
                txtNDD_ChucVu.Text=obj.NDD_CHUCVU + "";
                txtNDD_CQ.Text = obj.NDD_CQ + "";

                //obj.NDD_QUOCTICH;
                dropNDD_GIOITINH.SelectedValue = obj.NDD_GIOITINH != null ? obj.NDD_GIOITINH.ToString() : "-1";
                txtNDD_CMND.Text = obj.NDD_CMND;
                txtNgayCapCMND.Text = obj.NDD_NGAYCAP != null ? ((DateTime)obj.NDD_NGAYCAP).ToString("dd/MM/yyyy", cul) : "";
                txtNoiCapCMND.Text = obj.NDD_NOICAP;

                //---------------------------------------
                decimal tinh_id = string.IsNullOrEmpty(obj.TAMTRU_TINHID + "") ? 0 : (decimal)obj.TAMTRU_TINHID;
                if (tinh_id > 0)
                {
                    dropTamTru_Tinh.SelectedValue = tinh_id.ToString();

                    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTamTru_Tinh.SelectedValue), dropTamTru_Huyen, true);
                    decimal huyen_id = string.IsNullOrEmpty(obj.DIACHI_HUYEN_ID + "") ? 0 : (decimal)obj.DIACHI_HUYEN_ID;
                    if (huyen_id > 0)
                        dropTamTru_Huyen.SelectedValue = huyen_id.ToString();
                }
                txtTamTru_ChiTiet.Text = obj.DIACHI_CHITIET;
                
                //---------------------------------------
                txtNgheNghiep.Text = obj.NGHENGHIEP + "";
                txtTelephone.Text = obj.TELEPHONE;
                txtMOBILE.Text = obj.MOBILE;
                string TuCachTT = String.IsNullOrEmpty(obj.TUCACHTT) ? "" : obj.TUCACHTT;
                if (TuCachTT == "")
                    dropTuCachTT.SelectedIndex = 0;
                else
                {
                    Cls_Comon.SetValueComboBox(dropTuCachTT, obj.TUCACHTT);
                    if (TuCachTT == DUOCUYQUYEN)
                    {
                        pnUyQuyen.Visible = true;

                        try
                        {
                            LoadThongTinNguoiUyQuyen();
                        }catch(Exception ex) { }
                    }
                }
            }
        }
        void LoadThongTinNguoiUyQuyen()
        {
            DONKK_USERS_UYQUYEN objUQ = dt.DONKK_USERS_UYQUYEN.Where(x => x.DONKK_USERID == UserID).Single();
            if (objUQ != null)
            {
                txtNUQ_HOTEN.Text = objUQ.HOTEN;                
                dropNUQ_GIOITINH.SelectedValue = objUQ.GIOITINH + "";
                txtNgayUyQuyen.Text = objUQ.NGAYUYQUYEN != null ? ((DateTime)objUQ.NGAYUYQUYEN).ToString("dd/MM/yyyy", cul) : "";

                txtNUQ_NGAYSINH.Text = objUQ.NGAYSINH != null ? ((DateTime)objUQ.NGAYSINH).ToString("dd/MM/yyyy", cul) : "";
                txtNUQ_NamSinh.Text = objUQ.NAMSINH+"";
                Cls_Comon.SetValueComboBox(dropNUQ_QuocTich, objUQ.QUOCTICH);

                txtNUQ_CMND.Text = objUQ.CMND;
                txtNUQ_NgayCapCMND.Text = objUQ.NGAYCAPCMND != null ? ((DateTime)objUQ.NGAYCAPCMND).ToString("dd/MM/yyyy", cul) : "";
                txtNUQ_NoiCapCMND.Text = objUQ.NOICAPCMND;

                txtNUQ_Mobile.Text = objUQ.TELEPHONE;
                txtNUQ_Email.Text = objUQ.EMAIL;

                if (!String.IsNullOrEmpty(objUQ.TINHID + ""))
                {
                    Cls_Comon.SetValueComboBox(dropNUQ_Tinh, objUQ.TINHID);
                    if (objUQ.TINHID > 0)
                    {
                        LoadDMHanhChinhByParentID((decimal)objUQ.TINHID, dropNUQ_QuanHuyen, true);

                        if (!String.IsNullOrEmpty(objUQ.HUYENID + ""))
                            Cls_Comon.SetValueComboBox(dropNUQ_QuanHuyen, objUQ.TINHID);
                    }
                }
                txtNUQ_DCChiTiet.Text = objUQ.DIACHICT+"";
                if (!String.IsNullOrEmpty(objUQ.TENFILE + ""))
                {
                    lkFileUyQuyen.Text = objUQ.TENFILE;
                    pnGiayUyQuyen.Visible = true;
                }
                else
                    pnGiayUyQuyen.Visible = false; 
            }
        }
       
      
        void UploadFileUyQuyen(DONKK_USERS_UYQUYEN objUQ)
        {
            string folder_upload = "/TempUpload/";
            if (file_upload.HasFile)
            {
                String fileExtension =System.IO.Path.GetExtension(file_upload.FileName).ToLower();
                string file_name = file_upload.FileName;
                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                file_upload.PostedFile.SaveAs(file_path);

                byte[] buff = null;
                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);
                    objUQ.TENFILE = oF.Name;
                    objUQ.LOAIFILE = oF.Extension;
                    objUQ.NOIDUNGFILE = buff;
                    lkFileUyQuyen.Visible = true;
                    lkFileUyQuyen.Text = objUQ.TENFILE;
                }
                //xoa file
                File.Delete(file_path);
            }
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = lttThongBaoTop.Text = "";
            Update();
            // Response.Redirect("TaikhoanInfo.aspx");
        }
      
        void Update()
        {
            DONKK_USERS obj = new DONKK_USERS();
            string email = txtEMAIL.Text.Trim().ToLower();

            try
            {
                List<DONKK_USERS> lst = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower().Contains(email) && x.ID != UserID).ToList<DONKK_USERS>();
                if (lst != null && lst.Count > 0)
                {
                    lbthongbao.Text = lttThongBaoTop.Text = "Tài khoản này đã tồn tại, hãy kiểm tra lại.";
                    return;
                }
                else
                    obj = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            }
            catch (Exception ex){}

            obj.MUCDICH_SD = Convert.ToInt16(rdMucDichSD.SelectedValue);
            obj.EMAIL = txtEMAIL.Text.Trim();
            obj.TUCACHTT = dropTuCachTT.SelectedValue;

            obj.DN_MASOTHUE = txtDN_MASOTHUE.Text.Trim();
            obj.DN_GPDKKD = txtDN_GPDKKD.Text.Trim();
            obj.DN_TENVN = txtDN_TENVN.Text.Trim();
            obj.DN_TENEN = txtDN_TENEN.Text.Trim();
            obj.DN_TELEPHONE = txtDN_DienThoai.Text.Trim();
            obj.DN_DIACHI = txtDN_DiaChi.Text.Trim();
            obj.DN_TENKHAC = txtDN_othername.Text.Trim();

            obj.NDD_HOTEN = Cls_Comon.FormatTenRieng(txtNDD_HOTEN.Text.Trim());
            if (txtNDD_NGAYSINH.Text.Trim() != "")
                obj.NDD_NGAYSINH = DateTime.Parse(txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NDD_NAMSINH = Convert.ToDecimal(txtNamSinh.Text.Trim());

            obj.NDD_QUOCTICH = Convert.ToDecimal(dropQuocTich.SelectedValue);
            obj.NDD_CHUCVU = txtNDD_ChucVu.Text.Trim();
            obj.NDD_CQ = txtNDD_CQ.Text.Trim();
            //-----------------------------------
            if (dropNDD_GIOITINH.SelectedValue != "")
                obj.NDD_GIOITINH = Convert.ToInt32(dropNDD_GIOITINH.SelectedValue);

            //-----------------------------------
            obj.NDD_CMND = txtNDD_CMND.Text.Trim();
            if (txtNgayCapCMND.Text.Trim() != "")
                obj.NDD_NGAYCAP = DateTime.Parse(txtNgayCapCMND.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NDD_NOICAP = txtNoiCapCMND.Text.Trim();
           
            //------------thuong tru-tam tru-----------------------
            obj.TAMTRU_TINHID = obj.DIACHI_TINH_ID =  Convert.ToDecimal(dropTamTru_Tinh.SelectedValue);
            obj.TAMTRU_HUYEN = obj.DIACHI_HUYEN_ID = Convert.ToDecimal(dropTamTru_Huyen.SelectedValue);
            obj.TAMTRU_CHITIET = obj.DIACHI_CHITIET = txtTamTru_ChiTiet.Text.Trim();
            
            //------------------------------
            obj.NGHENGHIEP = txtNgheNghiep.Text.Trim();

            //---------------------------
            obj.TELEPHONE = txtTelephone.Text.Trim();
            obj.MOBILE = txtMOBILE.Text.Trim();

            obj.LASTLOGINDATE = DateTime.Now;
            obj.LASTLOGINIP= Cls_Comon.GetLocalIPAddress();
            obj.MODIFIEDDATE = DateTime.Now;

            if (dropTuCachTT.SelectedValue == DUOCUYQUYEN)
                obj.IS_DUOC_UYQUYEN = 1;
            else
                obj.IS_DUOC_UYQUYEN = 0;

            obj.TUCACHTT = dropTuCachTT.SelectedValue;

            dt.SaveChanges();
            if (obj.IS_DUOC_UYQUYEN == 1)
            {
               Update_NguoiUyQuyen(obj.ID, obj.NDD_HOTEN);
            }
            else
            {
                try
                {
                    DONKK_USERS_UYQUYEN objUQ = dt.DONKK_USERS_UYQUYEN.Where(x => x.DONKK_USERID == obj.ID).Single();
                    if (objUQ != null)
                    {
                        dt.DONKK_USERS_UYQUYEN.Remove(objUQ);
                        dt.SaveChanges();
                    }
                }
                catch(Exception ex) { }
            }

            lbthongbao.Text = lttThongBaoTop.Text= "<div class='msg_thongbao'>Cập nhật thông tin tài khoản thành công!</div>";
            if(!string.IsNullOrEmpty(hidDVCQGCode.Value))
            {
                //neu la thong tin tu DVCQG gui sang thi link sang phan nop don khoi kien
                Response.Redirect("/Personnal/GuiDonKien.aspx");
            }    
            //Response.Redirect("Danhsach.aspx");
        }
        void Update_NguoiUyQuyen(Decimal NguoiUyQuyenID, string NguoiTao)
        {
            Boolean IsUpdate = false;
            string email = txtEMAIL.Text;
            DONKK_USERS_UYQUYEN obj = null;
            try
            {
                obj = dt.DONKK_USERS_UYQUYEN.Where(x => x.DONKK_USERID == NguoiUyQuyenID).Single();
                if (obj != null)
                    IsUpdate = true;
                else
                    obj = new DONKK_USERS_UYQUYEN();
            }catch(Exception ex) { obj = new DONKK_USERS_UYQUYEN(); }

            obj.HOTEN = Cls_Comon.FormatTenRieng(txtNUQ_HOTEN.Text.Trim());            
            if (dropNUQ_GIOITINH.SelectedValue != "")
                obj.GIOITINH = Convert.ToInt32(dropNUQ_GIOITINH.SelectedValue);
            obj.NGAYUYQUYEN = DateTime.Parse(txtNgayUyQuyen.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.DONKK_USERID = NguoiUyQuyenID;
            try
            {
                UploadFileUyQuyen(obj);
                pnGiayUyQuyen.Visible = true;
            }catch(Exception ex) { }
            //-----------------------------------
            if (txtNUQ_NGAYSINH.Text.Trim() != "")
                obj.NGAYSINH = DateTime.Parse(txtNUQ_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NAMSINH = Convert.ToDecimal(txtNUQ_NamSinh.Text.Trim());
          
            //-----------------------------------
            obj.CMND = txtNUQ_CMND.Text.Trim();
            if (txtNUQ_NgayCapCMND.Text.Trim() != "")
                obj.NGAYCAPCMND = DateTime.Parse(txtNUQ_NgayCapCMND.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NOICAPCMND = txtNUQ_NoiCapCMND.Text.Trim();

            //-----------------------------------
            obj.QUOCTICH = Convert.ToDecimal(dropNUQ_QuocTich.SelectedValue);
            obj.TINHID = Convert.ToDecimal(dropNUQ_Tinh.SelectedValue);
            obj.HUYENID = Convert.ToDecimal(dropNUQ_QuanHuyen.SelectedValue);
            obj.DIACHICT = txtNUQ_DCChiTiet.Text.Trim();

            //---------------------------
            obj.TELEPHONE = txtNUQ_Mobile.Text.Trim();
            obj.EMAIL = txtNUQ_Email.Text.Trim();
          
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = NguoiTao;
                obj.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                dt.DONKK_USERS_UYQUYEN.Add(obj);
            }
            dt.SaveChanges();
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
        }
        protected void txtNamSinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNDD_NGAYSINH.Text))
            {
                if (!String.IsNullOrEmpty(txtNamSinh.Text))
                {
                    int namsinh = Convert.ToInt32(txtNamSinh.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtNDD_NGAYSINH.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtNDD_NGAYSINH.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtNDD_NGAYSINH.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                    }
                }
            }
        }
        protected void txtNUQ_NGAYSINH_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNDD_NGAYSINH.Text))
            {
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNDD_NGAYSINH.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_temp != DateTime.MinValue)
                {
                    txtNUQ_NamSinh.Text = date_temp.Year + "";
                }
            }
        }
        protected void dropNUQ_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropNUQ_Tinh.SelectedValue), dropNUQ_QuanHuyen, true);
            }
            catch (Exception ex) { }
        }

        protected void dropTuCachTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTuCachTT.SelectedValue == DUOCUYQUYEN)
            {
                pnUyQuyen.Visible = true;
                txtNUQ_HOTEN.Focus();
            }
            else
                pnUyQuyen.Visible = false;
        }

        protected void cmdDowload_Click(object sender, ImageClickEventArgs e)
        {
            DONKK_USERS_UYQUYEN objUQ = dt.DONKK_USERS_UYQUYEN.Where(x => x.DONKK_USERID == UserID).Single();
            if (objUQ != null)
                DowloadFile(objUQ);
        }
        protected void lkFileUyQuyen_Click(object sender, EventArgs e)
        {
            DONKK_USERS_UYQUYEN objUQ = dt.DONKK_USERS_UYQUYEN.Where(x => x.DONKK_USERID == UserID).Single();
            if (objUQ != null)
                DowloadFile(objUQ);
        }
        void DowloadFile(DONKK_USERS_UYQUYEN objUQ)
        {
            try
            {
                String LoaiFile = objUQ.LOAIFILE;
                String TenFile = objUQ.TENFILE;
                byte[] NoiDungFile = objUQ.NOIDUNGFILE;
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: NoiDungFile, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download"
                    , "window.location='" + Cls_Comon.GetRootURL()
                                          + "/DownloadFile.aspx?cacheKey=" + cacheKey
                                          + "&FileName=" + TenFile
                                          + "&Extension=" + LoaiFile + "';", true);
            }
            catch (Exception ex)
            {

            }
        }
    }
}