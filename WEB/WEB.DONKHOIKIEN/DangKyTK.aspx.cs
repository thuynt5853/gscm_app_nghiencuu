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

using System.IO;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using System.Data;

using VGCA;
using WEB.DONKHOIKIEN.DichVuCong;
using BL.DonKK;
using System.Text.RegularExpressions;

namespace WEB.DONKHOIKIEN
{
    public partial class DangKyTK : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int CurrYear = 0;
        String DUOCUYQUYEN = "DUOCUYQUYEN";
        string BIDON = "BIDON";
        String NGUYENDON = "NGUYENDON";
        public string HIDE_PASSWORD { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            //validate the code
            Regex rg = new Regex("^[a-zA-Z0-9-]*$");
            //ko co request, hoac du lieu null thi ko lam gi ca
            if (string.IsNullOrEmpty(Request["code"]) || Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] == null
                || rg.IsMatch(Request["code"]) == false)
            {
                Response.Redirect("/Login.aspx", false);
            }
            else
            {

                CurrYear = DateTime.Now.Year;
                if (!IsPostBack)
                {
                    //pnChuKySo.Visible = true;
                    //pnDangKy.Visible = cmdNext.Visible = false;
                    //Bo qua kiem tra chu ky so de xac thu qua dich vu cong
                    pnChuKySo.Visible = false;
                    pnDangKy.Visible = true;
                    //----------HD su dung chu ky so-------------
                    String ma = hddMa.Value;
                    LoadThongTinTinhTheoMa(lttGhiChu, ma);

                    //---------------------------
                    lttTenLoaiTK.Text = "Thông tin cá nhân";
                    LoadDrop();
                    LoadDropTuCachToTung();

                    dropTuCachTT.Attributes.Add("onchange", "CheckUyQuyen()");

                    lttTrangThai.Text = "<div class='no_ok'></div>";
                    //Set AuthCode to Session-------------------------
                    Session.Add("AuthCode", WebAuth.GetAuthCode());
                    LoadThongTinTinhTheoMa(lttMsgDK, "CheckDangKyTK");

                    LoadUserDVCQG();
                }
                //-----------them doan dk cho su kien upload file ------------------
                ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
                scriptManager.RegisterPostBackControl(this.cmdUpdate);
            }
        }
        void LoadUserDVCQG()
        {
            //validate the code
            Regex rg = new Regex("^[a-zA-Z0-9-]*$");
            //ko co request, hoac du lieu null thi ko lam gi ca
            if (string.IsNullOrEmpty(Request["code"]) || Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] == null 
                || rg.IsMatch(Request["code"]) == false)
            {
                return;
            }
            //fill cac thong tin vao cac truong tren form de thuc hien viec dang ky va hoan thien thong tin
            var _userInfo = (UserInforOutput)Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO];
            txtNDD_HOTEN.Text = _userInfo.HoVaTen;
            //txtNDD_CMND.Text = _userInfo.SoCMND;
            string _cmt = _userInfo.SoCMND;
            if (!string.IsNullOrEmpty(_userInfo.SoDinhDanh))
            {
                _cmt = _userInfo.SoDinhDanh;
            }
            txtNDD_CMND.Text = _cmt;

            if (Session[ENUM_SESSION.SESSION_MUCDICHSD] != null)
            {
                rdMucDichSD.SelectedValue = Session[ENUM_SESSION.SESSION_MUCDICHSD].ToString();
            }


            txtMOBILE.Text = _userInfo.SoDienThoai;
            //txtEMAIL.Text = _userInfo.ThuDienTu;
            try
            {
                DateTime _ngaysinh;
                if (DateTime.TryParseExact(_userInfo.NgayThangNamSinh, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out _ngaysinh))
                {
                    txtNDD_NGAYSINH.Text = _ngaysinh.ToString("dd/MM/yyyy");
                    txtNamSinh.Text = _ngaysinh.Year.ToString();
                }
            }
            catch { }
            if (!string.IsNullOrEmpty(Request["code"]))
                hidDVCQGCode.Value = Request["code"];
            this.HIDE_PASSWORD = "style='visibility:hidden'";
            ////chuyen sang form dang ky ko co ky so
            //cmdNext_KoCTS_Click(null, null);
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
                dropTuCachTT.Items.Add(new ListItem("Người được ủy quyền", "DUOCUYQUYEN"));
                string temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = "$" + row["MA"].ToString() + "$";
                    if (!MaTuCachKoSD.Contains(temp))
                        dropTuCachTT.Items.Add(new ListItem(row["Ten"].ToString(), row["MA"].ToString()));
                }
            }
        }
        void LoadThongTinTinhTheoMa(Literal control, string mathongbao)
        {
            DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
            String NoiDung = obj.GetNoiDungByMaTrang(mathongbao);
            if (!String.IsNullOrEmpty(NoiDung))
                control.Text = NoiDung;
        }
        void LoadDrop()
        {
            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            LoadDropByGroupName(dropNUQ_QuocTich, ENUM_DANHMUC.QUOCTICH, false);

            LoadDropByGroupName(dropLoaiUyQuyen, ENUM_DANHMUC.LOAIUYQUYEN, false);
            //-------------------------
            LoadDrop_DMHanhChinh();
        }
        void LoadDrop_DMHanhChinh()
        {
            Decimal ParentID = 0;
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(ParentID);
            ListItem item_root = new ListItem("------Chọn------", "0");

            dropTinh.Items.Clear();
            dropTamTru_Tinh.Items.Clear();
            dropNUQ_Tinh.Items.Clear();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTinh.Items.Add(new ListItem("------Tỉnh/Thành phố------", "0"));
                dropTamTru_Tinh.Items.Add(new ListItem("------Tỉnh/Thành phố------", "0"));
                dropNUQ_Tinh.Items.Add(item_root);
                foreach (DataRow row in tbl.Rows)
                {
                    dropTinh.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                    dropTamTru_Tinh.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                    dropNUQ_Tinh.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                }
            }

            try
            {
                ParentID = Convert.ToDecimal(dropTinh.SelectedValue);
                if(ParentID>0)
                    tbl = obj.GetAllByParentID(ParentID);

                dropQuan.Items.Clear();
                dropTamTru_Huyen.Items.Clear();
                dropNUQ_QuanHuyen.Items.Clear();
                dropQuan.Items.Add(new ListItem("------Quận/Huyện------", "0"));
                dropTamTru_Huyen.Items.Add(new ListItem("------Quận/Huyện------", "0"));
                dropNUQ_QuanHuyen.Items.Add(item_root);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        dropQuan.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                        dropTamTru_Huyen.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                        dropNUQ_QuanHuyen.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                    }
                }
            }
            catch (Exception ex) { }
        }
        void LoadDMHanhChinhByParentID(Decimal ParentID, DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = null;
            if (ParentID > 0)
                tbl = obj.GetAllByParentID(ParentID);
            if (tbl != null && tbl.Rows.Count>0)
            {
                foreach(DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
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
        }
        protected void dropTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTamTru_Tinh.SelectedValue), dropTamTru_Huyen, true);
            }
            catch (Exception ex) { }
        }

        //-----------------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            lblThongBaoTop.Text = lbthongbao.Text = "";
            string email = txtEMAIL.Text;
            if (!CheckExistEmail(email))
                Update();
        }
        //
        protected void cmdNotUpdate_Click(object sender, EventArgs e)
        {
            Session[ENUM_SESSION.SESSION_USERID] = "";
            Session[ENUM_SESSION.SESSION_USERNAME] = "";

            //Session[ENUM_SESSION.SESSION_DONVIID] = obj.DONVIID;
            Session[ENUM_SESSION.SESSION_LOAIUSER] = "";
            Session[ENUM_SESSION.SESSION_USERTEN] = "";
            Session[ENUM_SESSION.SESSION_TINH_ID] = "";
            Session[ENUM_SESSION.SESSION_QUAN_ID] = "";
            Session[ENUM_SESSION.SESSION_MUCDICHSD] = "";
            if (Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] != null)
            {
                var userInfo = (UserInforOutput)Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO];

                //goi logout tren he thong DVCQG
                //var objbapi = new CallApi(global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrl"]);
                //var inputModel = new revokeModel()
                //{
                //    client_id = global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientId"],
                //    client_secret = global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientSecret"],
                //    token= userInfo.access_token
                //};
                //xoa access token
                //objbapi.PostObjectRestApi<string>(DVCMethod.revoke, inputModel);
                Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] = null;
                var objbapi = new CallApi(global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrl"]);
                var inputModel = new logoutModel()
                {
                    id_token_hint = userInfo.id_token,
                    post_logout_redirect_uri = global::System.Configuration.ConfigurationManager.AppSettings["DVCCallBackPage"]

                };

                //objbapi.GetObjectRestApi<string>(string.Format("{0}?id_token_hint={1}&post_logout_redirect_uri={2}", global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrlLogout"]
                //, inputModel.id_token_hint,inputModel.post_logout_redirect_uri));
                Response.Redirect(string.Format("{0}?id_token_hint={1}&post_logout_redirect_uri={2}", global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrlLogout"]
                    , inputModel.id_token_hint, inputModel.post_logout_redirect_uri));
            }
            else
                Response.Redirect("/Trangchu.aspx");

        }
        void Update()
        {
            String Pass = txtPASSWORD.Text.Trim();
            //if (!string.IsNullOrEmpty(hidDVCQGCode.Value))
            //{
            //    //tao mat khau ngau nhien, neu dang dang ky tu tai khoan DVCQG
            //    Pass = Guid.NewGuid().ToString();
            //}
            DONKK_USERS obj = new DONKK_USERS();
            int CurrID = 0;
            string email = txtEMAIL.Text;
            obj.USERTYPE = Convert.ToInt32(radUSERTYPE.SelectedValue);
            obj.TUCACHTT = dropTuCachTT.SelectedValue;
            if (obj.TUCACHTT == DUOCUYQUYEN)
                obj.IS_DUOC_UYQUYEN = 1;
            else
                obj.IS_DUOC_UYQUYEN = 0;

            obj.EMAIL = email;
            obj.PASSWORD = Cls_Comon.MD5Encrypt(Pass );            

            obj.DN_MASOTHUE = (radUSERTYPE.SelectedValue != "2")? "":txtDN_MASOTHUE.Text.Trim();
            obj.DN_GPDKKD = (radUSERTYPE.SelectedValue != "2") ? "" : txtDN_GPDKKD.Text.Trim();
            obj.DN_TENVN = txtDN_TENVN.Text.Trim();
            obj.DN_TENEN = txtDN_TENEN.Text.Trim();
            obj.DN_TELEPHONE = (radUSERTYPE.SelectedValue == "1") ? "" : txtDN_DienThoai.Text.Trim();
            obj.DN_DIACHI = (radUSERTYPE.SelectedValue == "1") ? "" : txtDN_DiaChi.Text.Trim();
            obj.DN_TENKHAC= (radUSERTYPE.SelectedValue == "1") ? "" : txtDN_othername.Text.Trim();

            obj.NDD_HOTEN = txtNDD_HOTEN.Text.Trim();
            if (txtNDD_NGAYSINH.Text.Trim() != "")
                obj.NDD_NGAYSINH = DateTime.Parse(txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NDD_NAMSINH =Convert.ToDecimal( txtNamSinh.Text.Trim());

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

            ////-----------------------------------
            //obj.DIACHI_TINH_ID = Convert.ToDecimal(dropTinh.SelectedValue);
            //obj.DIACHI_HUYEN_ID = Convert.ToDecimal(dropQuan.SelectedValue);
            //obj.DIACHI_CHITIET = txtDiaChiCT.Text.Trim();
            //-----------------------------------
            obj.TAMTRU_TINHID = obj.DIACHI_TINH_ID = Convert.ToDecimal(dropTamTru_Tinh.SelectedValue);
            obj.TAMTRU_HUYEN = obj.DIACHI_HUYEN_ID = Convert.ToDecimal(dropTamTru_Huyen.SelectedValue);
            obj.TAMTRU_CHITIET = obj.DIACHI_CHITIET = txtTamTru_ChiTiet.Text.Trim();

            //------------------------------
            obj.NGHENGHIEP = txtNgheNghiep.Text.Trim();
            //---------------------------
            obj.TELEPHONE = txtTelephone.Text.Trim();
            obj.MOBILE = txtMOBILE.Text.Trim();
           
            obj.STATUS = 2;
            obj.MUCDICH_SD = 1;
            obj.DONVICAPCTSO = lttDonViCapCKSo.Text;

            if (CurrID == 0)
            {
                obj.ACTIVATIONCODE = Guid.NewGuid().ToString();
                obj.CREATEDATE = DateTime.Now;
                obj.MODIFIEDDATE = DateTime.Now;
                dt.DONKK_USERS.Add(obj);
            }
            else
                obj.MODIFIEDDATE = DateTime.Now;
            dt.SaveChanges();

            CurrID =(int)obj.ID;

            //-------------------------------
            try
            {
                Module.Common.Cls_SendMail.SendDangKyTK(obj.EMAIL, obj.NDD_HOTEN, obj.EMAIL, Pass);
            }catch(Exception ex) { }

            //-------------------------------
            if (radUSERTYPE.SelectedValue == "1")
            {
                if (dropTuCachTT.SelectedValue == "DUOCUYQUYEN")
                {
                    Update_NguoiUyQuyen(obj.ID, obj.NDD_HOTEN);
                }
            }

            //-----------------------------------
            //Response.Redirect("/Thongbao.aspx?code=regacc&uID="+CurrID);
            //Dang ky xong sẽ điều hướng về trang chu
            Login(obj);
        }
        void Login(DONKK_USERS row, string UrlPage = "/Personnal/GuiDonKien.aspx")
        {
            decimal UserID = row.ID;
            Session[ENUM_SESSION.SESSION_USERID] = UserID;
            Session[ENUM_SESSION.SESSION_USERNAME] = row.EMAIL;

            //Session[ENUM_SESSION.SESSION_DONVIID] = obj.DONVIID;
            Session[ENUM_SESSION.SESSION_TINH_ID] = row.DIACHI_TINH_ID;
            Session[ENUM_SESSION.SESSION_QUAN_ID] = row.DIACHI_HUYEN_ID;
            Session[ENUM_SESSION.SESSION_LOAIUSER] = row.USERTYPE;
            Session[ENUM_SESSION.SESSION_MUCDICHSD] = row.MUCDICH_SD;
            string temp = (string.IsNullOrEmpty(row.NDD_HOTEN)) ? row.EMAIL : row.NDD_HOTEN;
            int user_type = Convert.ToInt16(row.USERTYPE);
            if (user_type == 1)
                Session[ENUM_SESSION.SESSION_USERTEN] = temp;
            else
                Session[ENUM_SESSION.SESSION_USERTEN] = (string.IsNullOrEmpty(row.DN_TENVN)) ? temp : row.DN_TENVN;



            DONKK_USER_HISTORY_BL objLogBL = new DONKK_USER_HISTORY_BL();
            objLogBL.WriteLog(UserID, ENUM_HD_NGUOIDUNG_DKK.DANGNHAP, Session[ENUM_SESSION.SESSION_USERTEN].ToString() + " - Đăng nhập thành công");

            //------------------------
            //int MucDichSD = Convert.ToInt32(row.MUCDICH_SD);
            //DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
            //Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
            //switch (MucDichSD)
            //{
            //    case 1:
            //        if (TinhTrangSD)
            //            Response.Redirect("/Personnal/PersonalIndex.aspx", false);
            //        else
            //            Response.Redirect("/Personnal/GuiDonKien.aspx", false);
            //        break;
            //    case 2:
            //        if (TinhTrangSD)
            //            Response.Redirect("/Personnal/PersonalIndex.aspx", false);
            //        else
            //            Response.Redirect("/Personnal/DangKyNhanVB.aspx", false);
            //        break;
            //}
            //luon nhay toi trang gui don kien luc co y/c tu DVCQG
            int MucDichSD = Convert.ToInt32(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
            DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
            Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
            switch (MucDichSD)
            {
                case 1:
                    {
                        if (TinhTrangSD)
                            Response.Redirect("/Personnal/PersonalIndex.aspx", false);
                        else
                            Response.Redirect("/Personnal/GuiDonKien.aspx", false);

                        break;
                    }


                case 2:
                    {
                        if (TinhTrangSD)
                            Response.Redirect("/Personnal/PersonalIndex.aspx", false);
                        else
                            Response.Redirect("/Personnal/DangKyNhanVB.aspx", false);
                        break;
                    }

            }
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        void Update_NguoiUyQuyen(Decimal NguoiUyQuyenID, string NguoiTao)
        {
            DONKK_USERS_UYQUYEN obj = new DONKK_USERS_UYQUYEN();
            int CurrID = 0;
            string email = txtEMAIL.Text;

            obj.HOTEN = Cls_Comon.FormatTenRieng(txtNUQ_HOTEN.Text.Trim());
            if (dropNUQ_GIOITINH.SelectedValue != "")
                obj.GIOITINH = Convert.ToInt32(dropNUQ_GIOITINH.SelectedValue);
            obj.NGAYUYQUYEN = DateTime.Parse(txtNgayUyQuyen.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.DONKK_USERID = NguoiUyQuyenID;
            UploadFileUyQuyen(obj);
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

            if (CurrID == 0)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = NguoiTao;
                obj.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                dt.DONKK_USERS_UYQUYEN.Add(obj);
            }
            dt.SaveChanges();
        }
        //byte[] UploadFileUyQuyen()
        //{
        //    string file_path = "";
        //    string filename = "";
        //    byte[] buff = null;
        //    string folder_upload = "/TempUpload";
        //    string strPath = Server.MapPath(folder_upload);
        //    if (!Directory.Exists(strPath))
        //    {
        //        try
        //        {
        //            Directory.CreateDirectory(strPath);
        //        }
        //        catch (Exception ex)
        //        {
        //            throw ex;
        //        }
        //    }
        //    if (fileupload.HasFile)
        //    {
        //        //-----upload file len server
        //        filename = Path.GetFileName(fileupload.PostedFile.FileName);

        //        decimal file_size = fileupload.PostedFile.ContentLength / 1024 / 1024;
        //        if (file_size <= 2)
        //        {
        //             file_path = strPath + "\\" + filename;
        //            fileupload.PostedFile.SaveAs(file_path);

        //            //----------doc file vua duoc upload len server de lay noi dung-------------
        //            using (FileStream fs = File.OpenRead(file_path))
        //            {
        //                BinaryReader br = new BinaryReader(fs);
        //                FileInfo oF = new FileInfo(file_path);

        //                long numBytes = oF.Length;
        //                buff = br.ReadBytes((int)numBytes);
        //            }
        //            //xoa file
        //            File.Delete(file_path);
        //        }
        //        else
        //        {
        //            string temp = "Kích thước tài liệu đang chọn quá 2MB. Hãy kiểm tra lại";
        //            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
        //        }
        //    }
        //    return buff;
        //}
        void UploadFileUyQuyen(DONKK_USERS_UYQUYEN objUQ)
        {
            string folder_upload = "/TempUpload/";
            if (fileupload.HasFile)
            {
                String fileExtension = System.IO.Path.GetExtension(fileupload.FileName).ToLower();
                string file_name = fileupload.FileName;
                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                fileupload.PostedFile.SaveAs(file_path);

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
                }
                //xoa file
                File.Delete(file_path);
            }
        }
        void ClearForm()
        {
            txtDiaChiCT.Text = txtDN_TENEN.Text = "";
            txtDN_TENVN.Text = "";
            txtEMAIL.Text = txtNamSinh.Text = "";
            txtDN_GPDKKD.Text = txtDN_MASOTHUE.Text = "";
            txtNDD_CMND.Text = txtNDD_HOTEN.Text = txtNDD_NGAYSINH.Text = "";
            txtNgayCapCMND.Text = txtNoiCapCMND.Text = "";
            txtPASSWORD.Text = txtREPASSWORD.Text = "";
            txtTelephone.Text = txtMOBILE.Text = "";
            dropTinh.SelectedIndex = 1;
            dropQuan.SelectedValue = "0";
        }
        protected void txtNDD_NGAYSINH_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNDD_NGAYSINH.Text))
            {
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNDD_NGAYSINH.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNDD_NGAYSINH.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
              
                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);

                if (date_temp != DateTime.MinValue)
                {
                    if (date_temp > now)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNDD_NGAYSINH.ClientID);
                    }
                    else
                    {
                        txtNamSinh.Text = date_temp.Year.ToString();
                    }
                }
            }
        }
        protected void txtNamSinh_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtNDD_NGAYSINH.Text))
            {
                if (!String.IsNullOrEmpty(txtNamSinh.Text))
                {
                    namsinh = Convert.ToInt32(txtNamSinh.Text);
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

            if (!String.IsNullOrEmpty(txtNamSinh.Text))
            {
                namsinh = Convert.ToInt32(txtNamSinh.Text);
                if (namsinh > DateTime.Now.Year)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn Năm hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtNamSinh.ClientID);

                }
            }
        }

        //-----------------------------------------------------
        void SetControlByUserType()
        {
            dropTuCachTT.SelectedValue = NGUYENDON;
            switch (radUSERTYPE.SelectedValue)
            {
                case "1":
                    lttTenLoaiTK.Text = "Thông tin cá nhân";
                    plDoanhNghiep.Visible = false;
                    pnIsUyQuyen.Visible = true;
                    //rdIsUyQuyen.SelectedValue = "1";
                    break;
                case "2":
                    plDoanhNghiep.Visible = true;
                    lttTenLoaiTK.Text = "Người đại diện";
                    lttTitleDN.Text = "Thông tin doanh nghiệp";
                    lttTenDN.Text = "Tên tiếng Việt";
                    pnDNMaSoThue.Visible = true;
                    pnIsUyQuyen.Visible = false;

                    break;
                case "3":
                    plDoanhNghiep.Visible = true;
                    lttTenDN.Text = "Tên tổ chức";
                    lttTenLoaiTK.Text = "Người đại diện";
                    lttTitleDN.Text = "Thông tin Cơ quan/ Tổ chức";
                    pnDNMaSoThue.Visible = false;
                    pnEngName.Visible = false;
                    pnIsUyQuyen.Visible = false;
                    break;
            }
        }
        protected void radUSERTYPE_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetControlByUserType();
        }
        //-----------------------------------------------------
        //protected void rdIsUyQuyen_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    switch (rdIsUyQuyen.SelectedValue)
        //    {
        //        case "1":
        //            lttTenLoaiTK.Text = "Thông tin cá nhân";
        //            break;
        //        case "2":
        //            lttTenLoaiTK.Text = "Thông tin người được ủy quyền";
        //            break;
        //    }
        //}
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

        protected void cmdCheckChuKySo_Click(object sender, EventArgs e)
        {
            Check_ChuKySo();
        }
        protected void cmdNext_Click(object sender, EventArgs e)
        {
            //KT lai, tranh TH dung source visible nut next
            string authCode = Session["AuthCode"].ToString();
            string signature = Signature1.Value;
            WebAuth auth = new WebAuth(authCode, signature);
            if (auth.Validate())
            {
                string temp_email = auth.CertificateInfo.Email;
                if (!CheckExistEmail(temp_email))
                {
                    pnDangKy.Visible = true;
                    pnChuKySo.Visible = false;
                }
            }
        }
        
        void Check_ChuKySo()
        {
            try
            {
                string authCode = Session["AuthCode"].ToString();
                string signature = Signature1.Value;
                WebAuth auth = new WebAuth(authCode, signature);
                if (auth.Validate())
                {
                    lttTrangThai.Text = "<div class='ok'></div>";
                    String CMND = auth.CertificateInfo.UID;
                    CMND = CMND.Replace("CMND", "");
                    CMND = CMND.Replace(":", "");
                    lblCMND.Text = CMND;
                    //--------Xac nhan chu ky so thanh cong----------
                    string Subject = auth.Certificate.Subject;
                    string[] arr = Subject.Split(',');
                    string[] temp = null;
                    string tinh = "", quoctich = "", masothue;
                    foreach (string item in arr)
                    {
                        if (item.Length > 0)
                        {
                            temp = item.Trim().Split('=');
                            switch (temp[0] + "")
                            {
                                case "L":
                                    tinh = temp[1] + "";
                                    lttDiaChi.Text = tinh;
                                    txtDiaChiCT.Text = txtTamTru_ChiTiet.Text = tinh;
                                    break;
                                case "C":
                                    quoctich = temp[1] + "";
                                    lblQuocTich.Text = quoctich;
                                    break;
                                case "MST":
                                    masothue = temp[1] + "";
                                    txtDN_MASOTHUE.Text = masothue;
                                    txtDN_MASOTHUE.Enabled = false;
                                    lttMaSoThue.Text = masothue;
                                    pnDNMaSoThue.Visible = true;
                                    radUSERTYPE.SelectedValue = "2"; //Doanh nghiep
                                    SetControlByUserType();
                                    break;
                            }
                        }
                    }

                    //-------------------------------
                    pnDangKy.Visible = false;
                    pnThongTinCKSo.Visible = true;
                    cmdNext.Visible = true;

                    //-----------------------
                    String temp_hoten = auth.CertificateInfo.CommonName;
                    lblHoTen.Text = temp_hoten;
                    txtNDD_HOTEN.Text = temp_hoten;
                    txtNDD_HOTEN.Enabled = false;
                    //-----------------------------
                    txtNDD_CMND.Text = CMND;
                    if (String.IsNullOrEmpty(CMND + ""))
                        txtNDD_CMND.Enabled = true;
                    else
                        txtNDD_CMND.Enabled = false;

                    //-----------------------------
                    string temp_email = auth.CertificateInfo.Email;
                    txtEMAIL.Text = temp_email;
                    lttEmail.Text = temp_email;
                    txtEMAIL.Enabled = false;

                    string temp_coquan = auth.CertificateInfo.O;
                    string temp_donvi = auth.CertificateInfo.OU;
                    lttDonVi.Text = temp_coquan + ((String.IsNullOrEmpty(temp_donvi)) ? "" : (", " + temp_donvi));
                    txtNDD_CQ.Text = temp_coquan + ((String.IsNullOrEmpty(temp_donvi)) ? "" : (", " + temp_donvi)); ;
                    txtNDD_CQ.Enabled = false;

                    //-------------------------------------
                    try
                    {
                        dropQuocTich.SelectedValue = gsdt.DM_HANHCHINH.Where(x => x.TEN == quoctich).Single<DM_HANHCHINH>().ID.ToString();
                    }
                    catch (Exception ex) { }

                    //-------------------------------
                    Subject = auth.Certificate.Issuer;
                    arr = Subject.Split(',');
                    string str1 = "", str2 = "";
                    foreach (string item in arr)
                    {
                        if (item.Length > 0)
                        {
                            temp = item.Trim().Split('=');
                            switch (temp[0] + "")
                            {
                                case "CN":
                                    str1 = temp[1] + "";
                                    break;
                                case "O":
                                    str2 = temp[1] + "";
                                    break;
                            }
                        }
                    }
                    lttDonViCapCKSo.Text = str1 + ((String.IsNullOrEmpty(str2)) ? "" : (", " + str2));

                    //---------------------------
                    Boolean CheckExist = CheckExistEmail(temp_email);
                    if (CheckExist)
                        cmdNext.Visible = false;
                    
                }
                else
                {
                    string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính/VGCA Sign Service chưa được kích hoạt";
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
                    lttThongBao.Text = thongbao;
                }
            }
            catch (Exception ex)
            {
                // Response.Write("Lỗi: " + ex.Message);
                string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính/VGCA Sign Service chưa được kích hoạt";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
                lttThongBao.Text = thongbao;
            }
        }
        Boolean CheckExistEmail(string temp_email)
        {
            string email = temp_email.ToLower();
            /*-----KT: Chu ky so da duoc dk hay chua*/
            try
            {
                DONKK_USERS objUser = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower() == email).Single<DONKK_USERS>();
                if (objUser != null)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Địa chỉ email này đã được dùng đăng ký tài khoản trong hệ thống. Đề nghị kiểm tra lại!");
                    cmdNext.Visible = false;
                    return true;
                }
                else return false;
            }
            catch (Exception ex) { return false; }
        }
    }

}