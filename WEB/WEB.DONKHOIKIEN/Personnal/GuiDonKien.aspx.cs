
using System;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;

using DAL.DKK;
using DAL.GSTP;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHC;
using BL.GSTP.APS;
using BL.GSTP.ALD;
using VGCA;
using BL.DonKK.Model;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class GuiDonKien : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 2;
        public int CurrYear = 0;
        public decimal DonID = 0;
        public decimal DuongSuID = 0;
        public string UYQUYEN = "", BIDON = "", NGUYENDON = "", QUYENNVLQ = "", KHAC, NGUOIUYQUYEN = "";
        DateTime date_temp;
        int soluongkytu_noidung = 250;
        int STATUS_LUUTAM = 10;
        int STATUS_BOSUNG = 4;
        String Value_NG = "NG";

        private List<DONKK_DON_DUONGSU_TEMP> GetDataStoreSession()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP" + IdUser;
            if (Session[Key] == null)
            {
                return new List<DONKK_DON_DUONGSU_TEMP>();
            }
            else
            {
                return (List<DONKK_DON_DUONGSU_TEMP>)Session[Key];
            }
        }
        private void SetDataStoreSession(List<DONKK_DON_DUONGSU_TEMP> data)
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP" + IdUser;
            Session[Key] = data;
        }

        private List<DONKK_DON_DUONGSU_TEMP> GetDataStoreSessionADDNEW()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP_ADDNEW" + IdUser;
            if (Session[Key] == null)
            {
                return new List<DONKK_DON_DUONGSU_TEMP>();
            }
            else
            {
                return (List<DONKK_DON_DUONGSU_TEMP>)Session[Key];
            }
        }
        private void SetDataStoreSessionADDNEW(List<DONKK_DON_DUONGSU_TEMP> data)
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP_ADDNEW" + IdUser;
            Session[Key] = data;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrYear = DateTime.Now.Year;
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
            UYQUYEN = ENUM_DANSU_TUCACHTOTUNG.UYQUYEN;
            BIDON = ENUM_DANSU_TUCACHTOTUNG.BIDON;
            NGUYENDON = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
            NGUOIUYQUYEN = ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN;
            QUYENNVLQ = ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ;
            KHAC = ENUM_DANSU_TUCACHTOTUNG.KHAC;

            hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
            if (UserID > 0)
            {
                int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                if (MucDichSD == 2)
                    Response.Redirect("/Thongbao.aspx?code=error");

                if (!IsPostBack)
                {
                    Thongtinnguoiuyquyen.Visible = false;
                    SetDataStoreSession(null);
                    SetDataStoreSessionADDNEW(null);
                    //tam thoi bo chuc nang check ky so
                    //Session.Add("AuthCode", WebAuth.GetAuthCode());
                    lstTitleNguyendon.Text = "Người khởi kiện";
                    lstTitleBidon.Text = "Người bị kiện";
                    lttDsNguyenDonKhacTitle.Text = "<div class='title_ds_duongsu'>Danh sách người đồng khởi kiện</div>";
                    lttDsBiDonKhacTitle.Text = "<div class='title_ds_duongsu'>Danh sách người bị kiện khác</div>";

                    ClearDataTemp();

                    hddStatusDonKK.Value = STATUS_LUUTAM.ToString();
                    pnAddFile.Visible = true;

                    LoadDrop();
                    ddlND_Quoctich.SelectedValue = ddlBD_Quoctich.SelectedValue = QuocTichVN.ToString();
                    hddLinhVucVuViec.Value = rdLoaiAn.SelectedValue;
                    Boolean is_show = CheckQuyen_GuiDK();
                    if (is_show)
                    {
                        rdLoaiAn.SelectedValue = (String.IsNullOrEmpty(Request["loai"] + "")) ? "" : Request["loai"].ToString();
                        decimal current_id = (String.IsNullOrEmpty(Request["dID"] + "")) ? 0 : Convert.ToDecimal(Request["dID"] + "");
                        if (current_id > 0)
                        {
                            
                            LoadInfo(current_id);
                            //int status= (String.IsNullOrEmpty(Request["status"] + "")) ? 0 : Convert.ToInt16(Request["status"] + "");
                            //if (status == 1)
                            //{
                            //    //Cls_Comon.CallFunctionJS(this, this.GetType(), "ShowSuccesMsg('Đơn khởi kiện đã được lưu thành công!')");
                            //    lttMsg.Text = lttMsgTop.Text =  "Đơn khởi kiện đã được lưu thành công!";
                            //   // cmdLuu.Focus();
                            //}
                            //else if (status == 2)
                            //    Cls_Comon.CallFunctionJS(this, this.GetType(), "show_popup_in(" + hddDonKKID.Value + ")");
                        }
                        else
                        {
                            hddDonKKID.Value = "0";
                            CheckCurrUser();
                            LoadDuongSu();
                        }
                        Load_ddlToaanID();
                        Load_DsCacTaiLieuTheoLoaiDon();
                        LoadFileTheoDon();
                    }
                }

                //-----------them doan dk cho su kien upload file ------------------
                //chkND_ONuocNgoai.Attributes.Add("onchange", "CheckND_SongONuocNgoai()");
                //chkBD_ONuocNgoai.Attributes.Add("onchange", "CheckBD_SongONuocNgoai()");
                dropLoaiQDHanhChinh.Attributes.Add("onchange", "SetTitleLoaiQDHC()");
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void ClearDataTemp()
        {
            DONKK_DON_BL objBL = new DONKK_DON_BL();
            objBL.DeleteDonTemp(Session[ENUM_SESSION.SESSION_USERNAME].ToString());
        }
        Boolean CheckQuyen_GuiDK()
        {
            string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();
            int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
            if (MucDichSD == 2)
                pnDonKien.Visible = false;
            else
                pnDonKien.Visible = true;
            return pnDonKien.Visible;
        }

        void CheckCurrUser()
        {
            DONKK_USERS objUser = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            if (objUser != null)
            {
                ddlLoaiNguyendon.SelectedValue = objUser.USERTYPE.ToString();
                if (ddlLoaiNguyendon.SelectedValue == "1")
                {
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;

                    int IsDuocUyQuyen = (string.IsNullOrEmpty(objUser.IS_DUOC_UYQUYEN + "")) ? 0 : Convert.ToInt16(objUser.IS_DUOC_UYQUYEN);

                    rdUyQuyen.SelectedValue = IsDuocUyQuyen.ToString();
                    if (rdUyQuyen.SelectedValue == "2")
                    {
                        pnUyQuyen.Visible = true;
                        lstTitleNguyendon.Text = "Thông tin người được ủy quyền";
                    }
                    else
                    {
                        pnUyQuyen.Visible = false;
                        lstTitleNguyendon.Text = "Người khởi kiện";
                    }
                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                }
                FillDataOfCurrLogin();
            }
        }

        //------------------------------------
        #region LoadDrop
        void LoadDrop()
        {
            if (UserID > 0)
            {
                try
                {
                    Decimal QuanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_QUAN_ID] + "");
                    DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.HANHCHINHID == QuanID).Single<DM_TOAAN>();
                    if (objTA != null)
                    {
                        //txtToaAn.Text = objTA.MA_TEN;
                        //ddlToaanID.Text = objTA.MA_TEN;
                        hddToaAnID.Value = objTA.ID.ToString();
                        ddlToaanID.SelectedValue = objTA.ID.ToString();
                    }
                }
                catch (Exception ex) { }
            }

            //-----------------------
            LoadDrop_QHPL_DanSu();

            //--------Quoc tich----------------
            LoadDropQuocTich();
            //----------DM hanh chinh : tinh, Quan/huyen------------
            LoadDropDMHanhChinh();
        }
        void LoadDrop_QHPL_DanSu()
        {
            DM_DATAITEM_BL dataitemBL = new DM_DATAITEM_BL();
            DataTable tblQHPL = dataitemBL.GetAllQHPL_KoPhaiHanhChinh(ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC);
            dropQHPL.Items.Clear();
            dropQHPL.Items.Add(new ListItem("---Chưa xác định---", "0"));
            if (tblQHPL != null && tblQHPL.Rows.Count > 0)
            {
                foreach (DataRow row in tblQHPL.Rows)
                    dropQHPL.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        void LoadDrop_QHPL_HanhChinh()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tblQHPL = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC);
            dropQHPL.Items.Clear();
            dropQHPL.Items.Add(new ListItem("---Chưa xác định---", "0"));
            if (tblQHPL != null && tblQHPL.Rows.Count > 0)
            {
                foreach (DataRow row in tblQHPL.Rows)
                    dropQHPL.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        void LoadDropQuocTich()
        {
            try
            {
                DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
                DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
                foreach (DataRow row in tbl.Rows)
                {
                    ddlND_Quoctich.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
                    ddlBD_Quoctich.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
                }
            }
            catch (Exception ex) { }
        }
        void LoadDropDMHanhChinh()
        {
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            Decimal ParentID = 0;
            DataTable tbl = obj.GetAllByParentID(ParentID);
            //----------------
            dropToChuc_Tinh.Items.Clear();
            dropToChuc_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropToChuc_Tinh, tbl);

            dropTinh_TamTru.Items.Clear();
            dropTinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropTinh_TamTru, tbl);

            //-----------
            dropBD_Tinh_TamTru.Items.Clear();
            dropBD_Tinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropBD_Tinh_TamTru, tbl);

            dropToChuc_BD_Tinh.Items.Clear();
            dropToChuc_BD_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropToChuc_BD_Tinh, tbl);

            try
            {
                ParentID = Convert.ToDecimal(dropToChuc_Tinh.SelectedValue);
                if (ParentID > 0)
                {
                    tbl = obj.GetAllByParentID(ParentID);

                    dropToChuc_QuanHuyen.Items.Clear();
                    dropToChuc_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    LoadDMHanhChinh(dropToChuc_QuanHuyen, tbl);

                    dropQuanHuyen_TamTru.Items.Clear();
                    dropQuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    LoadDMHanhChinh(dropQuanHuyen_TamTru, tbl);

                    //--------------
                    dropBD_QuanHuyen_TamTru.Items.Clear();
                    dropBD_QuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    LoadDMHanhChinh(dropBD_QuanHuyen_TamTru, tbl);

                    dropTochuc_BD_QuanHuyen.Items.Clear();
                    dropTochuc_BD_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    LoadDMHanhChinh(dropTochuc_BD_QuanHuyen, tbl);
                }
                else
                {
                    dropToChuc_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    dropQuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    dropBD_QuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                    dropTochuc_BD_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                }
            }
            catch (Exception ex) { }
        }

        //----------------------------------------------      
        #region Drop dm tinh 
        void LoadDMHanhChinhByParentID(Decimal ParentID, DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(ParentID);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Quận/Huyện---", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
            }
        }
        void LoadDMHanhChinh(DropDownList drop, DataTable tbl)
        {
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
            }
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--- Chọn ---", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }

        protected void dropTinh_TamTru_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = true;
                if (dropTinh_TamTru.SelectedValue != Value_NG.ToString())
                {
                    //  chkND_ONuocNgoai.Checked = false;
                    //if (chkND_ONuocNgoai.Checked)
                    //{
                    //    Add_ValueNG(dropTinh_TamTru);
                    //    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = false;
                    //    dropQuanHuyen_TamTru.Visible = false;
                    //    Cls_Comon.SetFocus(this, this.GetType(), txtND_TTChitiet.ClientID);
                    //}
                    //else
                    //{
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = true;
                    dropQuanHuyen_TamTru.Visible = true;
                    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTinh_TamTru.SelectedValue), dropQuanHuyen_TamTru, true);
                    Cls_Comon.SetFocus(this, this.GetType(), dropQuanHuyen_TamTru.ClientID);
                    // }
                }
                else
                {
                    chkND_ONuocNgoai.Checked = false;
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = false;
                    dropQuanHuyen_TamTru.Visible = false;

                    Cls_Comon.SetFocus(this, this.GetType(), txtND_TTChitiet.ClientID);
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;
                }
            }
            catch (Exception ex) { }
        }

        //---------------------------       
        protected void dropBD_Tinh_TamTru_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                String tinh_tamtru = dropBD_Tinh_TamTru.SelectedValue;
                if (tinh_tamtru != Value_NG.ToString())
                {
                    //chkBD_ONuocNgoai.Checked = false;
                    //if (chkBD_ONuocNgoai.Checked)
                    //{
                    //    Add_ValueNG(dropBD_Tinh_TamTru);
                    //    lblBiDon_HuyenLabel.Visible = false;
                    //    dropBD_QuanHuyen_TamTru.Visible = false;
                    //    Cls_Comon.SetFocus(this, this.GetType(), txtBD_Tamtru_Chitiet.ClientID);
                    //}
                    //else
                    //{
                    lblBiDon_HuyenLabel.Visible = true;
                    dropBD_QuanHuyen_TamTru.Visible = true;
                    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropBD_Tinh_TamTru.SelectedValue), dropBD_QuanHuyen_TamTru, true);
                    Cls_Comon.SetFocus(this, this.GetType(), dropBD_QuanHuyen_TamTru.ClientID);
                    //}
                }
                else
                {
                    // chkBD_ONuocNgoai.Checked = false;
                    lblBiDon_HuyenLabel.Visible = false;
                    dropBD_QuanHuyen_TamTru.Visible = false;
                    Cls_Comon.SetFocus(this, this.GetType(), txtBD_Tamtru_Chitiet.ClientID);
                }
            }
            catch (Exception ex) { }
        }

        //--------------------------------------
        protected void dropToChuc_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
                Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_QuanHuyen.ClientID);
            }
            catch (Exception ex) { }
        }
        protected void dropToChuc_BD_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_BD_Tinh.SelectedValue), dropTochuc_BD_QuanHuyen, true);
                Cls_Comon.SetFocus(this, this.GetType(), dropTochuc_BD_QuanHuyen.ClientID);
            }
            catch (Exception ex) { }
        }
        #endregion

        protected void ddlLoaiBidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlLoaiBidon.SelectedValue)
            {
                case "1":
                    lblBD_HoTen.Text = "Họ tên";
                    pnBD_Canhan.Visible = true;
                    pnBD_Tochuc.Visible = false;
                    if (String.IsNullOrEmpty(txtTennguyendon.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_CMND.ClientID);
                    break;
                case "2":
                    lblBD_HoTen.Text = "Tên cơ quan";
                    pnBD_Canhan.Visible = false;
                    pnBD_Tochuc.Visible = true;
                    if (String.IsNullOrEmpty(txtBD_Ten.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Ten.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_BD_Tinh.ClientID);
                    break;
                case "3":
                    lblBD_HoTen.Text = "Tên tổ chức";
                    pnBD_Canhan.Visible = false;
                    pnBD_Tochuc.Visible = true;
                    if (String.IsNullOrEmpty(txtBD_Ten.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Ten.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_BD_Tinh.ClientID);
                    break;
            }
        }

        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlLoaiNguyendon.SelectedValue)
            {
                case "1":
                    lblND_HoTen.Text = "Họ tên";
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;

                    if (String.IsNullOrEmpty(txtTennguyendon.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_CMND.ClientID);
                    break;
                case "2":
                    lblND_HoTen.Text = "Tên cơ quan";
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                    if (String.IsNullOrEmpty(txtTennguyendon.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_Tinh.ClientID);
                    break;
                case "3":
                    lblND_HoTen.Text = "Tên tổ chức";
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                    if (String.IsNullOrEmpty(txtTennguyendon.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_Tinh.ClientID);
                    break;
            }
        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblND_Tinh.Text = "";
            lblND_HuyenLabel.Visible = lblND_Huyen.Visible = true;
            dropQuanHuyen_TamTru.Visible = true;

            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            Decimal ParentID = 0;
            DataTable tbl = obj.GetAllByParentID(ParentID);
            dropTinh_TamTru.Items.Clear();
            dropTinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropTinh_TamTru, tbl);
            dropQuanHuyen_TamTru.Items.Clear();
            dropQuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện--", "0"));
            chkND_ONuocNgoai.Checked = false;
            if (ddlND_Quoctich.SelectedValue == 2.ToString())
            {
                chkND_ONuocNgoai.Visible = true;
                lblND_Tinh.Text = lblND_Huyen.Text = "<span class='batbuoc'>*</span>";
                if (chkND_ONuocNgoai.Checked)
                {
                    Add_ValueNG(dropTinh_TamTru);
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = false;
                    dropQuanHuyen_TamTru.Visible = false;
                    lblND_Tinh.Text = lblND_Huyen.Text = "";
                }
                else
                {
                    dropTinh_TamTru.SelectedIndex = dropQuanHuyen_TamTru.SelectedIndex = 0;
                }
            }
            else
            {
                // chkND_ONuocNgoai.Visible = false;

                Add_ValueNG(dropTinh_TamTru);
                lblND_Tinh.Text = lblND_Huyen.Text = "";
                lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtND_Ngaysinh.ClientID);
        }

        void Add_ValueNG(DropDownList drop)
        {
            if (drop.Items.FindByValue(Value_NG) != null)
                drop.SelectedValue = Value_NG;
            else
            {
                drop.Items.Add(new ListItem("Nước ngoài", Value_NG));
                drop.SelectedValue = Value_NG;
            }
        }

        protected void chkND_CheckedChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedValue == 2.ToString())
            {
                lblND_Tinh.Text = lblND_Huyen.Text = "<span class='batbuoc'>*</span>";
                DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                Decimal ParentID = 0;
                DataTable tbl = obj.GetAllByParentID(ParentID);
                dropTinh_TamTru.Items.Clear();
                dropTinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
                LoadDMHanhChinh(dropTinh_TamTru, tbl);

                dropQuanHuyen_TamTru.Items.Clear();
                dropQuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện--", "0"));
                if (chkND_ONuocNgoai.Checked)
                {
                    lblND_Tinh.Text = lblND_Huyen.Text = "";
                    Add_ValueNG(dropTinh_TamTru);
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;

                }
                else
                {
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = true;
                }

            }
            else
            {
                dropQuanHuyen_TamTru.SelectedIndex = 0;
                lblND_Tinh.Text = "";

                Add_ValueNG(dropBD_Tinh_TamTru);
                lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;
            }
            if (chkND_ONuocNgoai.Checked)
            {
                lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;
                lblND_NoiCuTruLabel.Visible = lblND_Tinh.Visible = dropTinh_TamTru.Visible = false;
            }
            else
            {
                lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = true;
                lblND_NoiCuTruLabel.Visible = lblND_Tinh.Visible = dropTinh_TamTru.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), dropTinh_TamTru.ClientID);
        }

        protected void chkBD_CheckedChanged(object sender, EventArgs e)
        {
            //lbBiDon_Tinh.Text = lblBiDon_Huyen.Text = "";
            if (ddlBD_Quoctich.SelectedValue == 2.ToString())
            {
                DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                Decimal ParentID = 0;
                DataTable tbl = obj.GetAllByParentID(ParentID);
                dropBD_Tinh_TamTru.Items.Clear();
                dropBD_Tinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
                LoadDMHanhChinh(dropBD_Tinh_TamTru, tbl);
                dropBD_QuanHuyen_TamTru.Items.Clear();
                dropBD_QuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện--", "0"));

                if (chkBD_ONuocNgoai.Checked)
                {
                    Add_ValueNG(dropBD_Tinh_TamTru);
                    lblBiDon_HuyenLabel.Visible = false;
                    dropBD_QuanHuyen_TamTru.Visible = false;
                }
                else
                    lblBiDon_HuyenLabel.Visible = dropBD_QuanHuyen_TamTru.Visible = true;
            }
            else
            {
                //dropBD_Tinh_TamTru.SelectedIndex = 0;
                dropBD_QuanHuyen_TamTru.SelectedIndex = 0;
                Add_ValueNG(dropBD_Tinh_TamTru);

                lblBiDon_HuyenLabel.Visible = false;
                dropBD_QuanHuyen_TamTru.Visible = false;
            }
            if (chkBD_ONuocNgoai.Checked)
            {
                lblBiDon_HuyenLabel.Visible = dropBD_QuanHuyen_TamTru.Visible = false;
                ltlNoiCuTru.Visible = dropBD_Tinh_TamTru.Visible = false;
            }
            else
            {
                lblBiDon_HuyenLabel.Visible = dropBD_QuanHuyen_TamTru.Visible = true;
                ltlNoiCuTru.Visible = dropBD_Tinh_TamTru.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), dropBD_Tinh_TamTru.ClientID);
        }
        protected void ddlBD_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            Decimal ParentID = 0;
            lblBiDon_HuyenLabel.Visible = true;
            dropBD_QuanHuyen_TamTru.Visible = true;
            DataTable tbl = obj.GetAllByParentID(ParentID);
            dropBD_Tinh_TamTru.Items.Clear();
            dropBD_Tinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropBD_Tinh_TamTru, tbl);
            dropBD_QuanHuyen_TamTru.Items.Clear();
            dropBD_QuanHuyen_TamTru.Items.Add(new ListItem("---Quận/Huyện--", "0"));
            chkBD_ONuocNgoai.Checked = false;
            if (ddlBD_Quoctich.SelectedValue == 2.ToString())
            {
                chkBD_ONuocNgoai.Visible = true;

                if (chkBD_ONuocNgoai.Checked)
                {
                    lblBiDon_HuyenLabel.Visible = false;
                    Add_ValueNG(dropBD_Tinh_TamTru);
                }

                dropBD_Tinh_TamTru.SelectedIndex = 0;
                dropBD_QuanHuyen_TamTru.SelectedIndex = 0;
            }
            else
            {
                chkBD_ONuocNgoai.Visible = false;
                Add_ValueNG(dropBD_Tinh_TamTru);
                lblND_Tinh.Text = lblND_Huyen.Text = "";
                lblBiDon_HuyenLabel.Visible = false;
                dropBD_QuanHuyen_TamTru.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtBD_Ngaysinh.ClientID);
        }
        #endregion



        //--------------------------
        Boolean SendMail()
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            String TenVuViec = "";
            string MaThongBao = "XNGuiDonKien";
            String NoiDung = "", TieuDe = "";
            string CurrEmail = dt.DONKK_USERS.Where(x => x.ID == UserID).SingleOrDefault().EMAIL;

            String ToaAn = ddlToaanID.Text.Trim();
            //String ToaAn = txtToaAn.Text.Trim();
            DAL.GSTP.DM_TRANGTINH obj = gsdt.DM_TRANGTINH.Where(x => x.MATRANG == MaThongBao).SingleOrDefault();

            if (obj != null)
            {
                NoiDung = obj.NOIDUNG;
                TieuDe = obj.TENTRANG;
            }
            if (!String.IsNullOrEmpty(NoiDung))
            {
                if (dropQHPL.SelectedValue == "0")
                {
                    string noidung_short = Cls_Comon.CatXau(txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtNoidungdon.Text, soluongkytu_noidung);
                    TenVuViec = noidung_short;
                }
                else TenVuViec = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + dropQHPL.SelectedItem.Text;

                NoiDung = String.Format(NoiDung, ToaAn, CurrUserName, TenVuViec, DateTime.Now.ToString("dd/MM/yyyy", cul));
                NoiDung += "<i style='color: #e1101d'>Lưu ý: Đây là hộp thư tự động, vui lòng không trả lời lại.</i>";
                Boolean IsSendMAil = Cls_Comon.SendEmail(CurrEmail, TieuDe, NoiDung);
                return IsSendMAil;
            }
            else return false;
        }
        //----------------------------------------------
        void GhiLog(String KeyLog, DONKK_DON objDonKK)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            String Detail_Action = CurrUserName;
            //-----------------------------
            switch (KeyLog)
            {
                case ENUM_HD_NGUOIDUNG_DKK.GUIDONKKMOI:
                    Detail_Action += "- Gửi đơn khởi kiện mới.<br/>";
                    break;
            }

            Detail_Action += "- Vụ việc:" + "<br/>";
            Detail_Action += "+ Lĩnh vực: ";
            switch (objDonKK.MALOAIVUAN)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    Detail_Action += "Dân sự";
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Detail_Action += "Hành chính";
                    break;
            }
            Detail_Action += "<br/>";
            Detail_Action += "+ Số đơn khởi kiện:" + objDonKK.ID + "<br/>";
            Detail_Action += "+ Số vụ việc:" + objDonKK.VUANID + "<br/>";
            Detail_Action += "+ Mã vụ việc:" + objDonKK.MAVUVIEC + "<br/>";
            Detail_Action += "+ Tên vụ việc:" + objDonKK.TENVUVIEC;

            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, KeyLog, Detail_Action);
        }
        //----------------------------------------------
        private bool CheckValid()
        {
            if (ddlToaanID.SelectedValue == "0")
            {
                // lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Chưa nhập nơi gửi đơn</div>";
                return false;
            }
            if (txtTennguyendon.Text == "")
            {
                // lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Chưa nhập tên người bị kiện!</div>";
                return false;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                if (txtND_Namsinh.Text == "")
                {
                    // lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Chưa nhập năm sinh người bị kiện</div>";
                    return false;
                }
            }
            if (txtBD_Ten.Text == "")
            {
                //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Chưa nhập tên người khởi kiện</div>";
                return false;
            }
            return true;
        }
        private bool CheckValid_KoCoNYC()
        {
            if (!CheckValid())
                return false;
            if (chkKhongCoNYC2.Checked == false)
            {
                if (txtBD_Ten.Text == "")
                {
                    // lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Chưa nhập tên người khởi kiện</div>";
                    return false;
                }
            }
            return true;
        }

        //--------------------------
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtND_Ngaysinh.Text))
            {
                DateTime d;
                d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    if (d > now)
                    {
                        //  Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Ngaysinh.ClientID);
                    }
                    else
                    {
                        txtND_Namsinh.Text = d.Year.ToString();
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                    }
                }
            }
        }
        protected void txtND_Namsinh_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtND_Ngaysinh.Text))
            {
                if (!String.IsNullOrEmpty(txtND_Namsinh.Text))
                {
                    namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtND_Ngaysinh.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtND_Ngaysinh.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                    }
                }
            }
            if (!String.IsNullOrEmpty(txtND_Namsinh.Text))
            {
                namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                if (namsinh > DateTime.Now.Year)
                {
                    //   Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn Năm hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Năm sinh không thể lớn hơn năm hiện tại là " + CurrYear + ". Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                }
            }
        }

        //-----------------------------------------
        protected void txtBD_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtBD_Ngaysinh.Text))
            {
                DateTime d;
                d = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    if (d > now)
                    {
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Ngaysinh.ClientID);
                    }
                    else
                    {
                        txtBD_Namsinh.Text = d.Year.ToString();
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                    }
                }
            }
        }
        protected void txtBD_Namsinh_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtBD_Ngaysinh.Text))
            {
                if (!String.IsNullOrEmpty(txtBD_Namsinh.Text))
                {
                    namsinh = Convert.ToInt32(txtBD_Namsinh.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtBD_Ngaysinh.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtBD_Ngaysinh.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                    }
                }
            }
            if (!String.IsNullOrEmpty(txtBD_Namsinh.Text))
            {
                namsinh = Convert.ToInt32(txtBD_Namsinh.Text);
                if (namsinh > DateTime.Now.Year)
                {
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Năm sinh không thể lớn hơn năm hiện tại là " + CurrYear + ". Hãy kiểm tra lại!");

                    //  Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn Năm hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                }
            }
        }

        //-------------------------------
        void ClearForm()
        {
            txtNoidungdon.Text = "";
            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_TTChitiet.Text = "";
            chkND_ONuocNgoai.Checked = chkBD_ONuocNgoai.Checked = false;
            dropQuanHuyen_TamTru.SelectedIndex = 0;
            txtBD_Ten.Text = "";
            txtBD_CMND.Text = "";
            txtBD_Ngaysinh.Text = txtBD_Namsinh.Text = "";
            txtBD_Tamtru_Chitiet.Text = "";
            hddDonKKID.Value = "0";
            hddVuAnID.Value = "0";

            rptDuongSuKhac.Visible = false;
        }

        //-----------------------------------------
        void FillDataOfCurrLogin()
        {
            DONKK_USERS objUser = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            if (objUser != null)
            {
                txtTennguyendon.Text = objUser.NDD_HOTEN;

                switch (Convert.ToInt32(objUser.USERTYPE.GetValueOrDefault(0)))
                {
                    case 1:
                        //tk ca nhan
                        
                        dropTinh_TamTru.SelectedValue = objUser.TAMTRU_TINHID.ToString();
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(objUser.TAMTRU_TINHID), dropQuanHuyen_TamTru, true);
                        try
                        {
                            dropQuanHuyen_TamTru.SelectedValue = objUser.TAMTRU_HUYEN.ToString();
                        }
                        catch (Exception ex) { }
                        txtND_TTChitiet.Text = objUser.TAMTRU_CHITIET;
                        break;
                    default:
                        //tai khoan co quan/DN/Tochuc
                        dropToChuc_Tinh.SelectedValue = objUser.DIACHI_TINH_ID.ToString();
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(objUser.DIACHI_TINH_ID), dropToChuc_QuanHuyen, true);
                        try
                        {
                            dropToChuc_QuanHuyen.SelectedValue = objUser.DIACHI_HUYEN_ID.ToString();
                        }
                        catch (Exception ex) { }
                        txtToChuc_DiaChiCT.Text = objUser.DIACHI_CHITIET + "";
                        break;
                }

                //---------------------------
                txtND_CMND.Text = objUser.NDD_CMND;
                try
                {
                    ddlND_Quoctich.SelectedValue = objUser.NDD_QUOCTICH.ToString();
                }
                catch (Exception ex) { }
                ddlND_Gioitinh.SelectedValue = objUser.NDD_GIOITINH.ToString();
                txtND_Ngaysinh.Text = objUser.NDD_NGAYSINH != null ? ((DateTime)objUser.NDD_NGAYSINH).ToString("dd/MM/yyyy", cul) : "";
                txtND_Namsinh.Text = (String.IsNullOrEmpty(objUser.NDD_NAMSINH + "")) ? "0" : objUser.NDD_NAMSINH.ToString();
                txtND_Email.Text = objUser.EMAIL;
                txtND_Dienthoai.Text = objUser.MOBILE;
            }
        }

        //----------------------------
        #region File tai lieu       
        void LoadFileTheoDon()
        {
            int Status_DonKK = (String.IsNullOrEmpty(hddStatusDonKK.Value)) ? STATUS_LUUTAM : Convert.ToInt16(hddStatusDonKK.Value);
            Load_DsCacTaiLieuTheoLoaiDon();

            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value)) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
            String MaLoaiVuViec = rdLoaiAn.SelectedValue;
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID
                                                                       && x.LOAIDON == MaLoaiVuViec
                                                                       && x.DKKUSERID == UserID
                                                                       && x.TAILIEUID == 0
                                                                       ).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                rptFile.DataSource = lst;
                rptFile.DataBind();
                rptFile.Visible = true;
            }
            else rptFile.Visible = false;


            if (Status_DonKK != STATUS_LUUTAM && Status_DonKK != STATUS_BOSUNG)
            {
                pnAddFile.Visible = false;
                lttThaoTacFile.Text = "";
            }
            else
            {
                pnAddFile.Visible = true;
                lttThaoTacFile.Text = "<td style ='width: 70px;'>Xóa</td>";
            }
        }
        void Load_DsCacTaiLieuTheoLoaiDon()
        {
            String MaLoaiVuViec = rdLoaiAn.SelectedValue;
            decimal QuanHePhapLuatID = 0;// Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            List<DM_TAILIEU_DON> lst = dt.DM_TAILIEU_DON.Where(x => x.MALOAIDON == MaLoaiVuViec
                                                && x.MAQUANHEPL == QuanHePhapLuatID).ToList<DM_TAILIEU_DON>();
            if (lst != null && lst.Count > 0)
            {
                lttGhiChuTitle.Text = "Đơn khởi kiện cần cung cấp các tài liệu như sau:";
                rptGhiChu.DataSource = lst;
                rptGhiChu.DataBind();
            }
        }

        //protected void rptFile_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value)) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
        //        if (DonKKID > 0)
        //        {
        //            Panel pnXoaFile = (Panel)e.Item.FindControl("pnXoaFile");
        //            pnXoaFile.Visible = false;
        //        }
        //    }
        //}
        protected void rptFile_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "dowload":
                    DowloadFile(Convert.ToDecimal(e.CommandArgument));
                    break;
                case "Delete":
                    XoaFile(Convert.ToDecimal(e.CommandArgument));
                    LoadFileTheoDon();
                    break;
            }
        }
        void DowloadFile(Decimal FileID)
        {
            try
            {
                DONKK_DON_TAILIEU oND = dt.DONKK_DON_TAILIEU.Where(x => x.ID == FileID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
                }
            }
            catch (Exception ex)
            {
                lttThongBao.Text = ex.Message;
            }
        }
        protected void Tailieu_Upload_Complete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (Tailieu_Upload.HasFile)
                {
                    string strFileName = Tailieu_Upload.FileName;
                    string path = Server.MapPath("~/TempUpload/") + strFileName;
                    Tailieu_Upload.SaveAs(path);
                    path = path.Replace("\\", "/");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                    //--------------------
                    HttpContext.Current.Response.Write(Tailieu_Upload.PostedFile);
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        protected void cmdSaveFileAttach_Click(object sender, EventArgs e)
        {
            byte[] File_Attachs_Data = fu_FILE_ATTACT.FileBytes;
            String file_name = fu_FILE_ATTACT.FileName;
            String Nme_file_Comp = "";
            string fileEx = "";
            if (file_name != "")
            {
                if (file_name.LastIndexOf('.') > 0)
                {
                    fileEx = file_name.Substring(file_name.LastIndexOf('.'));
                }
                if (fileEx.ToUpper() != ".PDF")
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", " alert('File lựa chọn phải có định dạng là file .pdf');", true);
                    return;
                }
                if (fu_FILE_ATTACT.PostedFile.ContentLength > (2 * 1024 * 1024))
                {
                    //lttThongBao.Text = "";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", " alert('File lựa chọn phải nhỏ hơn hoặc bằng 2M');", true);
                    return;
                }
                Nme_file_Comp = file_name.Replace(" ", "_").Replace("-", "_");
            }
            if (Nme_file_Comp != "")
            {
                String MaLoaiVuViec = rdLoaiAn.SelectedValue;
                Decimal DonID = Convert.ToDecimal(hddDonKKID.Value);
                DONKK_DON_TAILIEU obj = new DONKK_DON_TAILIEU();
                obj = new DONKK_DON_TAILIEU();
                obj.DONID = DonID;
                obj.TAILIEUID = 0;
                obj.TENFILE = Nme_file_Comp;
                obj.LOAIFILE = fileEx;
                obj.TENTAILIEU = (String.IsNullOrEmpty(txtTenTaiLieu.Text.Trim() + "")) ? Nme_file_Comp : txtTenTaiLieu.Text.Trim();
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.DKKUSERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                obj.NGAYTAO = DateTime.Now;
                obj.NOIDUNG = File_Attachs_Data;
                obj.LOAIDON = MaLoaiVuViec;
                dt.DONKK_DON_TAILIEU.Add(obj);
                dt.SaveChanges();
                txtTenTaiLieu.Text = "";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Hi_fileEx", "top.$get(" + Hi_fileEx.ClientID + ").value = '';", true);
                LoadFileTheoDon();
                Cls_Comon.SetFocus(this, this.GetType(), cmdThemFileTL.ClientID);
            }
            else if (Nme_file_Comp == "")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", " alert('File Attach chưa được chọn');", true);
            }
        }
        protected void Save_File_Click(object sender, EventArgs e)
        {
            SaveFile_khong_kyso();
            txtTenTaiLieu.Text = "";
            LoadFileTheoDon();
            Cls_Comon.SetFocus(this, this.GetType(), cmdThemFileTL.ClientID);
        }
        void XoaFile(Decimal TaiLieuID)
        {
            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value + "")) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
            string folder_upload = "/TempUpload";
            string strPath = Server.MapPath(folder_upload);
            string file_path = "";
            DONKK_DON_TAILIEU obj = dt.DONKK_DON_TAILIEU.Where(x => x.DKKUSERID == UserID
                                                                 && x.DONID == DonKKID
                                                                 && x.ID == TaiLieuID).Single<DONKK_DON_TAILIEU>();
            if (obj != null)
            {
                dt.DONKK_DON_TAILIEU.Remove(obj);
                dt.SaveChanges();

                file_path = strPath + "\\" + obj.TENFILE;
                File.Delete(file_path);
                lttThongBao.Text = "Tài liệu được xóa thành công!";
            }
        }
        protected void cmdThemFileTL_Click(object sender, EventArgs e)
        {
            SaveFile_KySo();
            txtTenTaiLieu.Text = "";

            LoadFileTheoDon();
            Cls_Comon.SetFocus(this, this.GetType(), cmdThemFileTL.ClientID);
        }

        void SaveFile_KySo()
        {
            string folder_upload = "/TempUpload/";
            string file_kyso = hddFileKySo.Value;
            if (!String.IsNullOrEmpty(hddFileKySo.Value))
            {
                String[] arr = file_kyso.Split('/');
                string file_name = arr[arr.Length - 1] + "";

                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                String MaLoaiVuViec = rdLoaiAn.SelectedValue;
                Decimal DonID = Convert.ToDecimal(hddDonKKID.Value);
                DONKK_DON_TAILIEU obj = new DONKK_DON_TAILIEU();

                byte[] buff = null;

                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);

                    obj = new DONKK_DON_TAILIEU();
                    obj.DONID = DonID;
                    obj.TAILIEUID = 0;
                    obj.TENFILE = oF.Name;
                    obj.LOAIFILE = oF.Extension;
                    obj.TENTAILIEU = (String.IsNullOrEmpty(txtTenTaiLieu.Text.Trim() + "")) ? oF.Name : txtTenTaiLieu.Text.Trim();
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.DKKUSERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    obj.NGAYTAO = DateTime.Now;
                    obj.NOIDUNG = buff;
                    obj.LOAIDON = MaLoaiVuViec;

                    dt.DONKK_DON_TAILIEU.Add(obj);
                    dt.SaveChanges();
                }

                //xoa file
                File.Delete(file_path);
            }
        }
        void SaveFile_khong_kyso()
        {
            string folder_upload = "/TempUpload/";
            if (!String.IsNullOrEmpty(hddFilePath.Value))
            {
                String[] arr = hddFilePath.Value.Split('/');
                string file_name = arr[arr.Length - 1] + "";

                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                String MaLoaiVuViec = rdLoaiAn.SelectedValue;
                Decimal DonID = Convert.ToDecimal(hddDonKKID.Value);
                DONKK_DON_TAILIEU obj = new DONKK_DON_TAILIEU();

                byte[] buff = null;

                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);

                    obj = new DONKK_DON_TAILIEU();
                    obj.DONID = DonID;
                    obj.TAILIEUID = 0;
                    obj.TENFILE = oF.Name;
                    obj.LOAIFILE = oF.Extension;
                    obj.TENTAILIEU = (String.IsNullOrEmpty(txtTenTaiLieu.Text.Trim() + "")) ? oF.Name : txtTenTaiLieu.Text.Trim();
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.DKKUSERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    obj.NGAYTAO = DateTime.Now;
                    obj.NOIDUNG = buff;
                    obj.LOAIDON = MaLoaiVuViec;

                    dt.DONKK_DON_TAILIEU.Add(obj);
                    dt.SaveChanges();
                }
                //xoa file
                File.Delete(file_path);
            }
        }
        #endregion
        //-----------------------------------------------------------
        //void LockControl()
        //{
        //    dropToChuc_Tinh.Enabled = dropToChuc_QuanHuyen.Enabled = false;

        //    dropToChuc_BD_Tinh.Enabled = dropTochuc_BD_QuanHuyen.Enabled = false;
        //    dropBD_Tinh_TamTru.Enabled = dropBD_QuanHuyen_TamTru.Enabled = false;
        //    rdLoaiAn.Enabled = false;

        //    ddlBD_Gioitinh.Enabled = ddlBD_Quoctich.Enabled = ddlLoaiNguyendon.Enabled = ddlLoaiBidon.Enabled = false;

        //    txtBD_CMND.Enabled = txtBD_Dienthoai.Enabled = false;
        //    txtBD_Email.Enabled = txtBD_Fax.Enabled = false;
        //    txtBD_Namsinh.Enabled = txtBD_NDD_Chucvu.Enabled = txtBD_NDD_ten.Enabled = false;
        //    txtBD_Ngaysinh.Enabled = txtBD_Tamtru_Chitiet.Enabled = txtBD_Ten.Enabled = false;

        //    txtND_CMND.Enabled = txtND_Dienthoai.Enabled = txtND_Email.Enabled = false;
        //    txtND_Fax.Enabled =  txtND_Namsinh.Enabled = false;
        //    txtND_Ngaysinh.Enabled = txtND_TTChitiet.Enabled = false;

        //    txtNoidungdon.Enabled = false;
        //    txtSoconchuathanhnien.Enabled = txtTennguyendon.Enabled = txtTenTaiLieu.Enabled = false;
        //    txtToaAn.Enabled = txtToChuc_BD_DiaChiCT.Enabled = false;
        //    txtToChuc_DiaChiCT.Enabled = txtToChuc_NguoiDD.Enabled = false;
        //    txtToChuc_NguoiDD_ChucVu.Enabled = false;

        //    txtNoidungdon.Enabled = txtNoiDungQDHC.Enabled = false;
        //    dropLoaiQDHanhChinh.SelectedValue = "0";
        //    txtNoiDungQDHC.Enabled = txtQDHC_Cua.Enabled = false;
        //    txtSoQD.Enabled = txtQDHanhChinh.Enabled = txtTomTatHanhViHCBiKien.Enabled = false;
        //    txtThongTinDansu_Them.Enabled = false;
        //    lttLink.Visible = false;
        //}
        void LockDon_BoSungDL()
        {
            dropQHPL.Enabled = false;
            rdLoaiAn.Enabled = rdUyQuyen.Enabled = false;
            ddlLoaiNguyendon.Enabled = ddlND_Gioitinh.Enabled = false;
            txtTennguyendon.Enabled = false;
            txtND_CMND.Enabled = txtND_CMND.Enabled = txtND_CMND.Enabled = false;
            txtND_Email.Enabled = false;
            pnUyQuyen.Enabled = false;
        }
        void LoadInfo(Decimal CurrDonID)
        {
            hddDonKKID.Value = CurrDonID.ToString();
            Decimal VuAnID = 0;
            DONKK_DON obj = dt.DONKK_DON.Where(x => x.ID == CurrDonID).Single<DONKK_DON>();
            if (obj != null)
            {
                int trang_thai = (int)obj.TRANGTHAI;
                hddStatusDonKK.Value = trang_thai.ToString();
                if (trang_thai == STATUS_LUUTAM || trang_thai == STATUS_BOSUNG)
                {
                    cmdGuiDon.Visible = cmdLuu.Visible = cmdPrint.Visible = true;
                }
                else
                {
                    cmdGuiDon.Visible = cmdLuu.Visible = cmdPrint.Visible = false;
                    Response.Redirect("chitietdon.aspx?ID=" + CurrDonID);
                }

                VuAnID = (string.IsNullOrEmpty(obj.VUANID + "")) ? 0 : (Decimal)obj.VUANID;
                hddVuAnID.Value = VuAnID.ToString();

                Decimal ToaAnId = Convert.ToDecimal(obj.TOAANID);
                DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == ToaAnId).Single<DM_TOAAN>();
                if (objTA != null)
                {
                    //txtToaAn.Text = objTA.MA_TEN;
                   // ddlToaanID.Text = objTA.MA_TEN;
                    hddToaAnID.Value = objTA.ID.ToString();
                    ddlToaanID.SelectedValue = objTA.ID.ToString();

                }

                rdLoaiAn.SelectedValue = (obj.MALOAIVUAN == "AN_HANHCHINH") ? "AN_HANHCHINH" : "AN_DANSU";
                hddLinhVucVuViec.Value = obj.MALOAIVUAN;
                switch (obj.MALOAIVUAN)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        LoadDrop_QHPL_DanSu();
                        pnDanSu.Visible = true;
                        pnHanhChinh.Visible = pnHanhChinh2.Visible = false;
                        txtThongTinDansu_Them.Text = obj.THONGTINTHEM;
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        LoadDrop_QHPL_HanhChinh();
                        LoadDrop_LoaiQDHanhChinh();

                        pnDanSu.Visible = false;
                        txtThongTinDansu_Them.Text = "";

                        pnHanhChinh.Visible = pnHanhChinh2.Visible = true;
                        try { dropLoaiQDHanhChinh.SelectedValue = obj.LOAIQDHANHCHINHID + ""; } catch (Exception ex) { }

                        txtSoQD.Text = obj.SOQD + "";
                        txtQDHanhChinh.Text = obj.TENQD;
                        txtQDHC_Cua.Text = obj.QDHC_CUA;
                        txtTomTatHanhViHCBiKien.Text = obj.TOMTATHANHVIHCBIKIEN;
                        txtHanhViHC.Text = obj.HANHVIHC;
                        txtNgayQD.Text = (String.IsNullOrEmpty(obj.NGAYQD + "") || (obj.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul);
                        break;
                }

                txtNoidungdon.Text = obj.NOIDUNG;
                try { dropQHPL.SelectedValue = obj.QUANHEPHAPLUATID + ""; }
                catch (Exception ex) { }

                //------Load nguyen don/bidon dai dien-----------------------
                Load_DSChinh(CurrDonID);
                //-----------------------
                LoadDsNguyenDonKhac();
                LoadDsBiDonKhac();
                LoadDuongSu();

                //--------Load file---------    
                LoadFileTheoDon();
                if (dt.DONKK_DON_THAMGIATOTUNG.Count(s=>s.DONKKID== CurrDonID)>0)
                {
                    rdUyQuyen.SelectedValue = "2";
                    rdUyQuyen_SelectedIndexChanged(rdUyQuyen, null);
                }
                else
                {
                    rdUyQuyen.SelectedValue = "1";
                }
                //Khoa ko cho phep thay doi trang thaiuy quyen
                rdUyQuyen.Enabled = false;
                if (trang_thai == STATUS_BOSUNG)
                    LockDon_BoSungDL();

            }
        }
        void Load_DSChinh(Decimal DonKKID)
        {
            if (dt.DONKK_DON_THAMGIATOTUNG.Count(s => s.DONKKID == DonKKID) > 0)
            {
                DONKK_DON_THAMGIATOTUNG oDONKK = dt.DONKK_DON_THAMGIATOTUNG.FirstOrDefault(s => s.DONKKID == DonKKID);
                 //nếu có ủy quyền
                txtTennguyendon.Text=oDONKK.HOTEN;

                ddlLoaiNguyendon.SelectedValue=oDONKK.LOAIDUONGSU.HasValue? oDONKK.LOAIDUONGSU.Value.ToString():"0";
                txtND_CMND.Text=oDONKK.SOCMND;
                ddlND_Quoctich.SelectedValue=oDONKK.QUOCTICHID.HasValue ? oDONKK.QUOCTICHID.Value.ToString() : "0";
                chkND_ONuocNgoai.Checked=oDONKK.SINHSONG_NUOCNGOAI.Value==1 ? true : false;
                dropTinh_TamTru.SelectedValue = oDONKK.TAMTRUTINHID.HasValue ? oDONKK.TAMTRUTINHID.Value.ToString() : "0";
                dropToChuc_Tinh.SelectedValue = oDONKK.TAMTRUTINHID.HasValue ? oDONKK.TAMTRUTINHID.Value.ToString() : "0";
                LoadDMHanhChinhByParentID(Convert.ToDecimal(oDONKK.TAMTRUTINHID), dropQuanHuyen_TamTru, true);
                LoadDMHanhChinhByParentID(Convert.ToDecimal(oDONKK.TAMTRUTINHID), dropToChuc_QuanHuyen, true);
                dropQuanHuyen_TamTru.SelectedValue = oDONKK.TAMTRUID.HasValue ? oDONKK.TAMTRUID.Value.ToString() : "0";
                dropToChuc_QuanHuyen.SelectedValue = oDONKK.TAMTRUID.HasValue ? oDONKK.TAMTRUID.Value.ToString() : "0";
                txtND_TTChitiet.Text=oDONKK.TAMTRUCHITIET ;
                txtND_DiaChiCoQuan.Text=oDONKK.DIACHICOQUAN;
                txtND_Ngaysinh.Text = oDONKK.NGAYSINH.HasValue ? oDONKK.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                txtND_Namsinh.Text = oDONKK.NAMSINH.HasValue ? oDONKK.NAMSINH.Value.ToString() : "";
                ddlND_Gioitinh.SelectedValue = oDONKK.GIOITINH.HasValue ? oDONKK.GIOITINH.Value.ToString() : "0";


                txtND_Email.Text=oDONKK.EMAIL ;
                txtND_Dienthoai.Text=oDONKK.DIENTHOAI ;
                txtND_Fax.Text=oDONKK.FAX ;

                //-------Nguoi dai dien cua to chuc------------------
                txtToChuc_NguoiDD_ChucVu.Text=oDONKK.CHUCVU ;



                List<DONKK_DON_DUONGSU_TEMP> ListData = new List<DONKK_DON_DUONGSU_TEMP>();
                List<DONKK_DON_DUONGSU> data = dt.DONKK_DON_DUONGSU.Where(s => s.DONKKID == DonKKID && s.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                foreach (DONKK_DON_DUONGSU item in data)
                {
                    DONKK_DON_DUONGSU_TEMP oDuongSu = new DONKK_DON_DUONGSU_TEMP();
                    oDuongSu.ID = item.ID;
                    oDuongSu.ID_TEMP = Guid.NewGuid().ToString();
                    oDuongSu.DONKKID = DonKKID;
                    oDuongSu.ISDON = item.ISDON;
                    oDuongSu.DUONGSUID = item.DUONGSUID;
                    oDuongSu.STOPVB = item.STOPVB;
                    oDuongSu.TENDUONGSU = item.TENDUONGSU;
                    oDuongSu.ISDAIDIEN = item.ISDAIDIEN;
                    oDuongSu.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                    oDuongSu.ISDAIDIEN = item.ISDAIDIEN;

                    oDuongSu.LOAIDUONGSU = item.LOAIDUONGSU;
                    oDuongSu.SOCMND = item.SOCMND;
                    oDuongSu.QUOCTICHID = item.QUOCTICHID;

                    oDuongSu.NGAYSINH = item.NGAYSINH;
                    oDuongSu.THANGSINH = item.THANGSINH;
                    oDuongSu.NAMSINH = item.NAMSINH;
                    oDuongSu.GIOITINH = item.GIOITINH;
                    oDuongSu.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                    oDuongSu.CHUCVU = item.CHUCVU;
                    oDuongSu.EMAIL = item.EMAIL;
                    oDuongSu.DIENTHOAI = item.DIENTHOAI;
                    oDuongSu.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;
                    oDuongSu.FAX = item.FAX;
                    oDuongSu.TAMTRUTINHID = item.TAMTRUTINHID;
                    oDuongSu.HKTTTINHID = item.HKTTTINHID;
                    oDuongSu.TAMTRUID = item.TAMTRUID;
                    oDuongSu.HKTTID = item.HKTTID;
                    oDuongSu.TAMTRUCHITIET = item.TAMTRUCHITIET;
                    oDuongSu.HKTTCHITIET = item.HKTTCHITIET;
                    oDuongSu.DIACHICOQUAN = item.DIACHICOQUAN;
                    oDuongSu.NDD_DIACHIID = item.NDD_DIACHIID;

                    oDuongSu.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                    oDuongSu.TUCACHTOTUNG = item.TUCACHTOTUNG;
                    oDuongSu.MALOAIVUVIEC = item.MALOAIVUVIEC;
                    oDuongSu.NGAYTAO = item.NGAYTAO;
                    oDuongSu.NGUOITAO = item.NGUOITAO;
                    oDuongSu.NGUOITAOID = item.NGUOITAOID;
                    oDuongSu.NGAYSUA = item.NGAYSUA;
                    oDuongSu.NGUOISUA = item.NGUOISUA;
                    ListData.Add(oDuongSu);
                    
                }

                SetDataStoreSession(ListData);
                Thongtinnguoiuyquyen.LoadGrid();


                List<DONKK_DON_DUONGSU> lstDuongSu = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList<DONKK_DON_DUONGSU>();
                if (lstDuongSu != null && lstDuongSu.Count > 0)
                {
                    string type_ds = "";
                    lstTitleNguyendon.Text = "Thông tin người khởi kiện";
                    pnUyQuyen.Visible = false;
                    foreach (DONKK_DON_DUONGSU ds in lstDuongSu)
                    {
                        type_ds = ds.TUCACHTOTUNG_MA;
                        switch (type_ds)
                        {
                           
                            case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                                Load_BiDonDaiDien_DonKK(ds);
                                break;
                           
                        }
                    }
                }

            }
            else
            {
                List<DONKK_DON_DUONGSU> lstDuongSu = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID && (x.ISDAIDIEN == 1 || x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.UYQUYEN)).ToList<DONKK_DON_DUONGSU>();
                if (lstDuongSu != null && lstDuongSu.Count > 0)
                {
                    string type_ds = "";
                    lstTitleNguyendon.Text = "Thông tin người khởi kiện";
                    pnUyQuyen.Visible = false;
                    foreach (DONKK_DON_DUONGSU ds in lstDuongSu)
                    {
                        type_ds = ds.TUCACHTOTUNG_MA;
                        switch (type_ds)
                        {
                            case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                                Load_NguyenDonDaiDien_DonKK(ds);
                                break;
                            case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                                Load_BiDonDaiDien_DonKK(ds);
                                break;
                            case ENUM_DANSU_TUCACHTOTUNG.UYQUYEN:
                                rdUyQuyen.SelectedValue = "2";
                                pnUyQuyen.Visible = true;
                                lstTitleNguyendon.Text = "Thông tin người được ủy quyền";
                                Load_NguyenDonDaiDien_DonKK(ds);
                                break;
                        }
                    }
                }
            }
            
        }
        void Load_NguyenDonDaiDien_DonKK(DONKK_DON_DUONGSU oND)
        {
            txtTennguyendon.Text = oND.TENDUONGSU;
            txtND_CMND.Text = oND.SOCMND;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();

            ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            //ddlND_Quoctich_SelectedIndexChanged(null, null);
            switch (ddlLoaiNguyendon.SelectedValue)
            {
                case "1":
                    lblND_HoTen.Text = "Họ tên";
                    break;
                case "2":
                    lblND_HoTen.Text = "Tên cơ quan";
                    break;
                case "3":
                    lblND_HoTen.Text = "Tên tổ chức";
                    break;
            }
            //-------------------------------------
            DM_HANHCHINH dm = null;

            if (oND.LOAIDUONGSU == 1)
            {
                pnNDTochuc.Visible = false;
                pnNDCanhan.Visible = true;
                #region Ca nhan
                try
                {
                    DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                    dropTinh_TamTru.Items.Clear();
                    dropTinh_TamTru.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
                    Decimal ParentID = 0;
                    DataTable tbl = obj.GetAllByParentID(ParentID);
                    LoadDMHanhChinh(dropTinh_TamTru, tbl);
                    dropTinh_TamTru.SelectedValue = oND.TAMTRUTINHID.ToString();
                    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropTinh_TamTru.SelectedValue), dropQuanHuyen_TamTru, true);
                    Cls_Comon.SetValueComboBox(dropQuanHuyen_TamTru, oND.TAMTRUID);
                }
                catch (Exception ex) { }

                txtND_TTChitiet.Text = oND.TAMTRUCHITIET + "";
                txtND_DiaChiCoQuan.Text = oND.DIACHICOQUAN + "";
                //------------------------------------
                if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();

                Cls_Comon.SetValueComboBox(ddlND_Gioitinh, oND.GIOITINH);
                #endregion
            }
            else
            {
                pnNDTochuc.Visible = true;
                pnNDCanhan.Visible = false;
                #region  Nguoi dai dien cho to chuc-----------------
                try
                {
                    //do nguoidaidien ko luu thong tin tinh--> lay thong qua quanhuyenID (luu trong NDD_DIACHIID)
                    dm = gsdt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).Single<DM_HANHCHINH>();
                    if (dm != null)
                    {
                        dropToChuc_Tinh.SelectedValue = dm.CAPCHAID + "";
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
                        dropToChuc_QuanHuyen.SelectedValue = oND.NDD_DIACHIID + "";
                    }
                }
                catch (Exception ex) { }
                txtToChuc_DiaChiCT.Text = oND.NDD_DIACHICHITIET;
                txtToChuc_NguoiDD.Text = oND.NGUOIDAIDIEN;
                txtToChuc_NguoiDD_ChucVu.Text = oND.CHUCVU;
                #endregion
            }
            //------------------
            if (oND.SINHSONG_NUOCNGOAI != null)
                chkND_ONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
            if (ddlND_Quoctich.SelectedIndex > 0)
                chkND_ONuocNgoai.Visible = false;
            else
                chkND_ONuocNgoai.Visible = true;
            if (chkND_ONuocNgoai.Checked)
            {
                Add_ValueNG(dropTinh_TamTru);
                if (oND.TAMTRUTINHID == 0)
                {
                    dropTinh_TamTru.SelectedValue = Value_NG;
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;
                }
            }
            else
            {
                if (ddlND_Quoctich.SelectedValue != 2.ToString())
                {
                    Add_ValueNG(dropTinh_TamTru);
                    lblND_HuyenLabel.Visible = lblND_Huyen.Visible = dropQuanHuyen_TamTru.Visible = false;

                }
            }
            //---------------------------
            txtND_Email.Text = oND.EMAIL + "";
            txtND_Dienthoai.Text = oND.DIENTHOAI + "";
            txtND_Fax.Text = oND.FAX + "";
        }
        void Load_BiDonDaiDien_DonKK(DONKK_DON_DUONGSU oBD)
        {
            txtBD_Ten.Text = oBD.TENDUONGSU;
            txtBD_CMND.Text = oBD.SOCMND;

            ddlLoaiBidon.SelectedValue = oBD.LOAIDUONGSU.ToString();
            switch (ddlLoaiBidon.SelectedValue)
            {
                case "1":
                    lblBD_HoTen.Text = "Họ tên";
                    break;
                case "2":
                    lblBD_HoTen.Text = "Tên cơ quan";
                    break;
                case "3":
                    lblBD_HoTen.Text = "Tên tổ chức";
                    break;
            }

            //-------------------------------------
            DM_HANHCHINH dm = null;
            if (oBD.LOAIDUONGSU == 1)
            {
                pnBD_Tochuc.Visible = false;
                pnBD_Canhan.Visible = true;

                txtBD_Email.Text = oBD.EMAIL + "";
                txtBD_Dienthoai.Text = oBD.DIENTHOAI + "";
                txtBD_Fax.Text = oBD.FAX + "";


                if (oBD.NGAYSINH != DateTime.MinValue)
                    txtBD_Ngaysinh.Text = ((DateTime)oBD.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtBD_Namsinh.Text = oBD.NAMSINH == 0 ? "" : oBD.NAMSINH.ToString();

                ddlBD_Gioitinh.SelectedValue = oBD.GIOITINH.ToString();
            }
            else
            {
                pnBD_Tochuc.Visible = true;
                pnBD_Canhan.Visible = false;
                #region  Nguoi dai dien cho to chuc-----------------
                txtBD_NDD_ten.Text = oBD.NGUOIDAIDIEN;
                txtBD_NDD_Chucvu.Text = oBD.CHUCVU;
                txtToChuc_BD_DiaChiCT.Text = oBD.NDD_DIACHICHITIET;
                try
                {
                    //do nguoidaidien ko luu thong tin tinh
                    //--> lay thong qua quanhuyenID (luu trong NDD_DIACHIID)                
                    dm = gsdt.DM_HANHCHINH.Where(x => x.ID == oBD.NDD_DIACHIID).Single<DM_HANHCHINH>();
                    if (dm != null)
                    {
                        dropToChuc_BD_Tinh.SelectedValue = dm.CAPCHAID.ToString();
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_BD_Tinh.SelectedValue), dropTochuc_BD_QuanHuyen, true);
                        dropTochuc_BD_QuanHuyen.SelectedValue = oBD.NDD_DIACHIID + "";
                    }
                }
                catch (Exception ex) { }
                #endregion
            }
            //----------------------------------
            ddlBD_Quoctich.SelectedValue = oBD.QUOCTICHID.ToString();
            dropBD_Tinh_TamTru.SelectedValue = oBD.TAMTRUTINHID.ToString();
            if (ddlBD_Quoctich.SelectedValue == 2.ToString())
            {
                chkBD_ONuocNgoai.Visible = true;
                if (oBD.SINHSONG_NUOCNGOAI != null)
                    chkBD_ONuocNgoai.Checked = oBD.SINHSONG_NUOCNGOAI == 1 ? true : false;

                if (chkBD_ONuocNgoai.Checked)
                {
                    Add_ValueNG(dropBD_Tinh_TamTru);
                    if (oBD.TAMTRUTINHID == 0)
                    {
                        dropBD_Tinh_TamTru.SelectedValue = Value_NG;
                        dropBD_QuanHuyen_TamTru.Visible = false;
                    }
                    else
                    {
                        dropBD_Tinh_TamTru.SelectedValue = oBD.TAMTRUTINHID.ToString();
                        dropBD_QuanHuyen_TamTru.Visible = true;
                    }
                }
                else
                {
                    try
                    {
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(dropBD_Tinh_TamTru.SelectedValue), dropBD_QuanHuyen_TamTru, true);
                        Cls_Comon.SetValueComboBox(dropBD_QuanHuyen_TamTru, oBD.TAMTRUID);
                    }
                    catch (Exception ex) { }
                }
            }
            else
            {
                chkBD_ONuocNgoai.Visible = false;
                Add_ValueNG(dropBD_Tinh_TamTru);
                lblBiDon_HuyenLabel.Visible = false;
                dropBD_QuanHuyen_TamTru.Visible = false;
            }

            txtBD_Tamtru_Chitiet.Text = oBD.TAMTRUCHITIET;
            txtBD_DiaChiCoQuan.Text = oBD.DIACHICOQUAN + "";
            //-------------------------------------
            if (ddlLoaiBidon.SelectedValue == "1")
            {
                pnBD_Canhan.Visible = true;
                pnBD_Tochuc.Visible = false;
            }
            else
            {
                pnBD_Canhan.Visible = false;
                pnBD_Tochuc.Visible = true;
            }
        }

        private void SetEnableNYC2(bool blnFlag)
        {
            ddlLoaiBidon.Enabled = txtBD_Ten.Enabled = blnFlag;
            dropToChuc_BD_Tinh.Enabled = dropTochuc_BD_QuanHuyen.Enabled = txtToChuc_BD_DiaChiCT.Enabled = blnFlag;
            txtBD_NDD_ten.Enabled = txtBD_NDD_Chucvu.Enabled = txtBD_CMND.Enabled = ddlBD_Quoctich.Enabled = ddlBD_Gioitinh.Enabled = blnFlag;
            txtBD_Ngaysinh.Enabled = txtBD_Namsinh.Enabled = chkBD_ONuocNgoai.Enabled = blnFlag;
            dropBD_QuanHuyen_TamTru.Enabled = dropBD_Tinh_TamTru.Enabled = blnFlag;
            txtBD_Tamtru_Chitiet.Enabled = txtBD_Email.Enabled = blnFlag;
            txtBD_Dienthoai.Enabled = txtBD_Fax.Enabled = blnFlag;
        }
        protected void chkKhongCoNYC2_CheckedChanged(object sender, EventArgs e)
        {
            SetEnableNYC2(chkKhongCoNYC2.Checked ? false : true);
        }

        #region Nguyen don khac
        protected void cmdLoadDsNguyenDonKhac_Click(object sender, EventArgs e)
        {
            LoadDsNguyenDonKhac();
            Cls_Comon.SetFocus(this, this.GetType(), "lkThemND");
        }
        void LoadDsNguyenDonKhac()
        {
            DataTable tbl = LoadDsDuongSuTheoMaTuCachTT(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptNguyenDonKhac.DataSource = tbl;
                rptNguyenDonKhac.DataBind();
                rptNguyenDonKhac.Visible = lttDsNguyenDonKhacTitle.Visible = true;
            }
            else
                rptNguyenDonKhac.Visible = lttDsNguyenDonKhacTitle.Visible = false;
        }

        public DataTable LoadDsDuongSuTheoMaTuCachTT(string ma_tucach_tt)
        {
            DataTable tbl = null;
            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value + "")) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
            string MaLoaiVuViec = rdLoaiAn.SelectedValue;
            string CurrUserEmail = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            string temp = "";
            DONKK_DON_DUONGSU_BL oBL = new DONKK_DON_DUONGSU_BL();
            tbl = oBL.GetDuongSuByUser(UserID, DonKKID, MaLoaiVuViec, ma_tucach_tt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = (string.IsNullOrEmpty(row["TamTruChiTiet"] + "")) ? "" : row["TamTruChiTiet"].ToString();
                    temp += (string.IsNullOrEmpty(row["TamTru_Huyen"] + "")) ? "" : ((temp.Length > 0) ? ", " + row["TamTru_Huyen"].ToString() : row["TamTru_Huyen"].ToString());
                    temp += (string.IsNullOrEmpty(row["TamTru_Tinh"] + "")) ? "" : ((temp.Length > 0) ? ", " + row["TamTru_Tinh"].ToString() : row["TamTru_Tinh"].ToString());
                    row["TamTruChiTiet"] = temp;
                }
            }
            return tbl;
        }
        protected void rptNguyenDonKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id, "NGUYENDON");
                    LoadDsNguyenDonKhac();
                    break;
            }
        }
        //protected void rptNguyenDonKhac_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        ImageButton imgXoa = (ImageButton)e.Item.FindControl("imgXoa");
        //        decimal current_id = (String.IsNullOrEmpty(Request["dID"] + "")) ? 0 : Convert.ToDecimal(Request["dID"] + "");
        //        if (current_id > 0)
        //            imgXoa.Visible = false;
        //    }
        //}
        #endregion

        #region Bi don khac
        protected void cmdLoadDsBiDonKhac_Click(object sender, EventArgs e)
        {
            LoadDsBiDonKhac();
            Cls_Comon.SetFocus(this, this.GetType(), "lkBiDon");
        }
        void LoadDsBiDonKhac()
        {
            DataTable tbl = LoadDsDuongSuTheoMaTuCachTT(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptBiDonKhac.DataSource = tbl;
                rptBiDonKhac.DataBind();
                rptBiDonKhac.Visible = lttDsBiDonKhacTitle.Visible = true;
            }
            else
                rptBiDonKhac.Visible = lttDsBiDonKhacTitle.Visible = false;
        }
        protected void rptBiDonKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id, "BIDON");
                    LoadDsBiDonKhac();
                    break;
            }
        }
        //protected void rptBiDonKhac_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        ImageButton imgXoa = (ImageButton)e.Item.FindControl("imgXoa");
        //        decimal current_id = (String.IsNullOrEmpty(Request["dID"] + "")) ? 0 : Convert.ToDecimal(Request["dID"] + "");
        //        if (current_id > 0)
        //            imgXoa.Visible = false;
        //    }
        //}
        #endregion

        //-------------------
        #region Ds Duong su khac
        protected void cmdLoadDsDuongSu_Click(object sender, EventArgs e)
        {
            LoadDsDuongSuKhac();
            Cls_Comon.SetFocus(this, this.GetType(), "lkDuongSuKhac");
        }
        void LoadDuongSu()
        {
            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value + "")) ? 0 : Convert.ToDecimal(hddDonKKID.Value);

            lttLink.Text = " <a href='javascript:;' id='lkDuongSuKhac' onclick='show_popup_by_loaids(\"" + ENUM_DANSU_TUCACHTOTUNG.KHAC + "\")'";
            lttLink.Text += " class='link_them_duongsu float_right align_right them_user'>Thêm</a>";
            lttLink.Visible = true;
            LoadDsDuongSuKhac();
        }
        public void LoadDsDuongSuKhac()
        {
            DataTable tbl = null;
            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value + "")) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
            string MaLoaiVuViec = rdLoaiAn.SelectedValue;
            string CurrUserEmail = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            DONKK_DON_DUONGSU_BL oBL = new DONKK_DON_DUONGSU_BL();
            tbl = oBL.GetDuongSuKhac(UserID, DonKKID, MaLoaiVuViec);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = tbl.Rows.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(20)).ToString();
                lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rptDuongSuKhac.DataSource = tbl;
                rptDuongSuKhac.DataBind();
                pnDuongSu.Visible = rptDuongSuKhac.Visible = true;
                pnPagingDSKhacTop.Visible = PpnPagingDSKhacBottom.Visible = true;
            }
            else
            {
                pnDuongSu.Visible = true;
                lstSobanghiT.Visible = false;
                rptDuongSuKhac.Visible = false;
                pnPagingDSKhacTop.Visible = PpnPagingDSKhacBottom.Visible = false;
            }
        }
        protected void rptDuongSuKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id, "DUONGSUKHAC");
                    LoadDsDuongSuKhac();
                    break;
            }
        }
        protected void rptDuongSuKhac_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //ImageButton imgXoa = (ImageButton)e.Item.FindControl("imgXoa");
                //decimal current_id = (String.IsNullOrEmpty(Request["dID"] + "")) ? 0 : Convert.ToDecimal(Request["dID"] + "");
                //imgXoa.Visible = false;
            }
        }
        public void xoa(decimal id, string TypeDoiTuong)
        {
            //KT: Neu da co GSTP.DonID --> xoa trong phan GSTP 
            //ko co --> xoa trong DOnKK
            DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            decimal DONID = (decimal)oND.DONKKID;
            if (oND.ISDAIDIEN == 1)
                return;
            dt.DONKK_DON_DUONGSU.Remove(oND);
            dt.SaveChanges();
            if (TypeDoiTuong == "NGUYENDON")
                lttMsgNguyenDon.Text = "Mục được chọn đã xóa thành công";
            else if (TypeDoiTuong == "BIDON")
                lttMsgBiDon.Text = "Mục được chọn đã xóa thành công!";
            else if (TypeDoiTuong == "DUONGSUKHAC")
                lttMsgDS.Text = "Mục được chọn đã xóa thành công";
            LoadDsDuongSuKhac();
        }

        #region "Phân trang ds duong su"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDsDuongSuKhac();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = "1";
            LoadDsDuongSuKhac();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDsDuongSuKhac();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDsDuongSuKhac();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDsDuongSuKhac();
        }

        #endregion
        #endregion
        protected void rdLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            string Loai_An = rdLoaiAn.SelectedValue;
            hddLinhVucVuViec.Value = Loai_An;

            //int Status_DonKK = (String.IsNullOrEmpty(hddStatusDonKK.Value)) ? STATUS_LUUTAM : Convert.ToInt16(hddStatusDonKK.Value);
            //if (Status_DonKK != STATUS_BOSUNG)
            //    hddLinhVucVuViec.Value = rdLoaiAn.SelectedValue;
            trLydoLyhon.Visible = pnKoCoNYC.Visible = false;
            switch (rdLoaiAn.SelectedValue)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    LoadDrop_QHPL_DanSu();
                    ddlLoaiQuanhe.SelectedValue = "2";
                    pnDanSu.Visible = true;
                    pnHanhChinh.Visible = pnHanhChinh2.Visible = false;
                    break;
                //-----------------------------------------
                case ENUM_LOAIAN.AN_HANHCHINH:
                    pnDanSu.Visible = false;
                    ddlLoaiQuanhe.SelectedValue = "1";
                    pnHanhChinh.Visible = pnHanhChinh2.Visible = true;
                    LoadDrop_LoaiQDHanhChinh();
                    LoadDrop_QHPL_HanhChinh();
                    break;
            }
            LoadDuongSu();
            //------------------------------
            Load_DsCacTaiLieuTheoLoaiDon();
            LoadFileTheoDon();

            //-----------------------------
            // Cls_Comon.CallFunctionJS(this, this.GetType(), "Check_LinhVucVuViec()");
            Cls_Comon.CallFunctionJS(this, this.GetType(), "CheckUyQuyen()");
            Cls_Comon.SetFocus(this, this.GetType(), ddlLoaiNguyendon.ClientID);
        }
        void LoadDrop_LoaiQDHanhChinh()
        {
            LoadDropByGroupName(dropLoaiQDHanhChinh, ENUM_DANHMUC.LOAIQD_HC, true);
        }
        protected void rdUyQuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdUyQuyen.SelectedValue == "2")
            {
                pnThemNguoiKhoiKienKhac.Visible = false;
                pnUyQuyen.Visible = true;
                Thongtinnguoiuyquyen.LoadGrid();
                lstTitleNguyendon.Text = "Thông tin người được ủy quyền";
                Thongtinnguoiuyquyen.Visible = true;
            }
            else
            {
                pnThemNguoiKhoiKienKhac.Visible = true;
                pnUyQuyen.Visible = false;
                lstTitleNguyendon.Text = "Thông tin người khởi kiện";
                Thongtinnguoiuyquyen.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
        }


        //---------------------------------------------------
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            if (ValidateForm())
            {
                int Status_DonKK = (String.IsNullOrEmpty(hddStatusDonKK.Value)) ? STATUS_LUUTAM : Convert.ToInt16(hddStatusDonKK.Value);
                Update_DonKhoiKien(Status_DonKK);
                rdUyQuyen.Enabled = false;
                lttMsg.Text = lttMsgTop.Text = "Đơn khởi kiện đã được lưu thành công!";
                MenuDon.LoadData();

                //if (hddIsNew.Value =="1")
                //{
                //    if (hddStatus.Value == STATUS_LUUTAM.ToString())
                //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Đơn khởi kiện đã được lưu thành công!");
                //    Response.Redirect("/Personnal/GuiDonKien.aspx?dID=" + hddDonKKID.Value + "&&status=1");
                //}
            }
        }

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            if (ValidateForm())
            {
                int Status_DonKK = (String.IsNullOrEmpty(hddStatusDonKK.Value)) ? STATUS_LUUTAM : Convert.ToInt16(hddStatusDonKK.Value);
                Update_DonKhoiKien(Status_DonKK);
                rdUyQuyen.Enabled = false;
                Decimal CurrDonKKID = Convert.ToDecimal(hddDonKKID.Value);
                String MaLoaiVV = hddLinhVucVuViec.Value.Trim();
                lttMsg.Text = lttMsgTop.Text = "Đơn khởi kiện đã được lưu thành công!";
                MenuDon.LoadData();
                Cls_Comon.CallFunctionJS(this, this.GetType(), "show_popup_in(" + CurrDonKKID + ")");
            }
        }

        protected void cmdGuiDon_Click(object sender, EventArgs e)
        {
            if (ValidateForm())
            {
                //check ky so hop le moi cho gui donkk sử dụng mã xác thực dịch vụ công 
                //if (Check_ChuKySo())
                //{
                Update_DonKhoiKien(0);
                DangKyNhanVBTongDatOnline();
                rdUyQuyen.Enabled = false;
                Boolean IsSendMail = SendMail();
                //---------------------
                if (hddStatus.Value == "0")
                {
                    //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn đã gửi đơn thành công!");
                    //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Đơn đã gửi thành công, không thực hiện gửi lại");
                    //if (IsSendMail)
                    //    Response.Redirect("/Thongbao.aspx?code=guidonkk_email");
                    //else
                    //    Response.Redirect("/Thongbao.aspx?code=guidonkk_noemail");
                    clearButton();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", " alert('Bạn đã gửi đơn thành công!');", true);
                    //Response.Redirect("/Personnal/GuiDonKien.aspx?status=0");
                }
                else
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Đơn khởi kiện đã được cập nhật thành công!");
                    Response.Redirect("/Personnal/Dsdon.aspx?status=0");
                }
                //}
            }
        }
        void clearButton()
        {
            txtBD_Ten.Text = "";
            txtBD_NDD_ten.Text = "";
            txtBD_NDD_Chucvu.Text = "";
            txtBD_CMND.Text = "";
            txtBD_Tamtru_Chitiet.Text = "";
            txtBD_DiaChiCoQuan.Text = "";
            txtBD_Email.Text = "";
            txtBD_Dienthoai.Text = "";
            txtNoidungdon.Text = "";

        }
        void DangKyNhanVBTongDatOnline()
        {
            Decimal CurrDonID = Convert.ToDecimal(hddDonKKID.Value);
            String MaDangKy = Cls_Comon.Randomnumber();
            String Group_DK = Guid.NewGuid().ToString();
            Decimal QLAn_DuongSuID = 0;

            DONKK_DON objDon = null;
            DONKK_DON_DUONGSU objDS = null;
            if (CurrDonID > 0)
            {
                try
                {
                    objDon = dt.DONKK_DON.Where(x => x.ID == CurrDonID).Single<DONKK_DON>();
                    objDS = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == CurrDonID && x.ISDAIDIEN == 1 && x.ISDON == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).Single();
                }
                catch (Exception ex) { objDon = new DONKK_DON(); }
            }

            DONKK_USER_DKNHANVB obj = new DONKK_USER_DKNHANVB();
            obj.GROUPDK = Group_DK;
            obj.TOAANID = objDon.TOAANID;
            obj.DONKKID = objDon.ID;
            obj.MALOAIVUVIEC = objDon.MALOAIVUAN;

            obj.VUVIECID = 0;
            obj.MAVUVIEC = "";
            obj.TENVUVIEC = objDon.TENVUVIEC;
            if (objDS != null)
            {
                obj.DUONGSUID = QLAn_DuongSuID;
                obj.TENDUONGSU = objDS.TENDUONGSU;
                obj.CMND = objDS.SOCMND;
                if (rdUyQuyen.SelectedValue == "1")
                {
                    obj.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                }
                else
                {
                    obj.TUCACHTOTUNG_MA = "TGTTDS_01";

                }
                obj.TUCACHTOTUNG_ID = gsdt.DM_DATAITEM.Where(x => x.MA == obj.TUCACHTOTUNG_MA).FirstOrDefault().ID;
            }

            obj.USERID = UserID;
            obj.NGAYTAO = DateTime.Now;

            int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
            if (MucDichSD == 1)
                obj.TRANGTHAI = 1;
            else
                obj.TRANGTHAI = 0;

            obj.MADANGKY = MaDangKy;
            dt.DONKK_USER_DKNHANVB.Add(obj);
            dt.SaveChanges();

        }
        Boolean Check_ChuKySo()
        {
            string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính ";
            thongbao += "hoặc VGCA Sign Service chưa được kích hoạt";

            Boolean retval = true;
            try
            {
                string authCode = Session["AuthCode"].ToString();
                string signature = Signature1.Value;
                WebAuth auth = new WebAuth(authCode, signature);
                if (auth.Validate())
                {
                    String CMND = auth.CertificateInfo.UID;
                    CMND = CMND.Replace("CMND", "");
                    CMND = CMND.Replace(":", "");

                    string cks_email = auth.CertificateInfo.Email;

                    //-----KT-----------------------
                    string CurrEmail = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    if (cks_email == CurrEmail)
                        retval = true;
                    else
                    {
                        retval = false;
                        thongbao = "Thông tin trong chứng thư số không trùng khớp với thông tin trong tài khoản.";
                        thongbao += "Bạn hãy kiểm tra lại!";
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
                        lttThongBao.Text = thongbao;
                    }
                }
                else
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
                    lttThongBao.Text = thongbao;
                    retval = false;
                }
            }
            catch (Exception ex)
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
                lttThongBao.Text = thongbao;
                retval = false;
            }
            return retval;
        }
        Boolean ValidateForm()
        {
            if (String.IsNullOrEmpty(txtNoidungdon.Text))
            {
                // lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'></div>";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Bạn chưa nhập nội dung đơn khởi kiện. Hãy kiểm tra lại!");
                Cls_Comon.SetFocus(this, this.GetType(), txtNoidungdon.ClientID);
                return false;
            }
            //-----KT da nhap thong tin nguoi uy quyen chua 
            //     (trong TH chon nguoi uy quyen)------------
            if (rdUyQuyen.SelectedValue == "2")
            {
                //string loai_an = rdLoaiAn.SelectedValue;
                //Decimal CurrUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                //try
                //{
                //    Decimal DonKKID = String.IsNullOrEmpty(hddDonKKID.Value) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
                //    String TuCachTT = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                //    DONKK_DON_DUONGSU obj = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID
                //                                                         && x.TUCACHTOTUNG_MA == TuCachTT
                //                                                         && x.ISDAIDIEN == 1
                //                                                         && x.MALOAIVUVIEC == loai_an
                //                                                         && x.NGUOITAOID == CurrUser
                //                                                      ).Single<DONKK_DON_DUONGSU>();
                //    if (obj != null)
                //    { }
                //    else
                //    {
                //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập thông tin người ủy quyền!");
                //        Cls_Comon.SetFocus(this, this.GetType(), pnUyQuyen.ClientID);
                //        return false;
                //    }
                //}
                //catch (Exception ex)
                //{
                //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập thông tin người ủy quyền!");
                //    Cls_Comon.SetFocus(this, this.GetType(), pnUyQuyen.ClientID);
                //    return false;
                //}
                List<DONKK_DON_DUONGSU_TEMP> obj = GetDataStoreSession();
                if (obj.Count==0)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập thông tin người ủy quyền!");
                    Cls_Comon.SetFocus(this, this.GetType(), pnUyQuyen.ClientID);
                    return false;
                }

            }
            return true;
        }

        void Update_DonKhoiKien(int trangthai)
        {
            int Status_DonKK = (String.IsNullOrEmpty(hddStatusDonKK.Value)) ? STATUS_LUUTAM : Convert.ToInt16(hddStatusDonKK.Value);

            Boolean IsUpdate = false;
            DONKK_DON obj = new DONKK_DON();
            Decimal CurrDonID = (String.IsNullOrEmpty(hddDonKKID.Value)) ? 0 : Convert.ToDecimal(hddDonKKID.Value + "");
            #region Update don khoi kien
            if (CurrDonID > 0)
            {
                try
                {
                    obj = dt.DONKK_DON.Where(x => x.ID == CurrDonID).Single<DONKK_DON>();
                    if (obj != null)
                        IsUpdate = true;
                }
                catch (Exception ex) { obj = new DONKK_DON(); }
            }
            if (!IsUpdate)
                hddIsNew.Value = "1";
            else
                hddIsNew.Value = "0";

            hddStatus.Value = (IsUpdate) ? "1" : "0";
            obj.LOAIANID = 0;
            string loai_an = hddLinhVucVuViec.Value;
            obj.MALOAIVUAN = hddLinhVucVuViec.Value;
            obj.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
            if (loai_an == ENUM_LOAIAN.AN_HANHCHINH)
            {
                obj.LOAIQDHANHCHINHID = Convert.ToDecimal(dropLoaiQDHanhChinh.SelectedValue);
                obj.SOQD = txtSoQD.Text.Trim();
                date_temp = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYQD = date_temp;
                obj.TENQD = txtQDHanhChinh.Text.Trim();
                obj.HANHVIHC = txtHanhViHC.Text.Trim();

                obj.QDHC_CUA = txtQDHC_Cua.Text;
                obj.TOMTATHANHVIHCBIKIEN = txtTomTatHanhViHCBiKien.Text;
                obj.NOIDUNGQUYETDINH = txtNoiDungQDHC.Text;
            }
            else
                obj.THONGTINTHEM = txtThongTinDansu_Them.Text.Trim();


            obj.TOAANID = Convert.ToDecimal(ddlToaanID.SelectedValue);
            obj.TENNGUOIGUI = txtTennguyendon.Text;

            date_temp = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYSINH = date_temp;
            obj.NAMSINH = (String.IsNullOrEmpty(txtND_Namsinh.Text + "")) ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);

            obj.DIACHI_TAMTRU = txtND_TTChitiet.Text.Trim();
            obj.DIENTHOAI = txtND_Dienthoai.Text;
            obj.FAX = txtND_Fax.Text;
            obj.STOPVB = 0;

            obj.TRANGTHAI = trangthai;
            obj.NOIDUNG = txtNoidungdon.Text;
            //không có ủy quyền
            if (rdUyQuyen.SelectedValue == "1")
            {
                if (dropQHPL.SelectedValue == "0")
                {
                    string noidung_short = Cls_Comon.CatXau(txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtNoidungdon.Text, soluongkytu_noidung);
                    obj.TENVUVIEC = noidung_short;
                }
                else
                    obj.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + dropQHPL.SelectedItem.Text;
            }
            else
            {
                //có ủy quyền
                List<DONKK_DON_DUONGSU_TEMP> lstDs = GetDataStoreSession();
                if (lstDs.Count>0)
                {
                    var ds = lstDs[0];
                    if (dropQHPL.SelectedValue == "0")
                    {
                        string noidung_short = Cls_Comon.CatXau(ds.TENDUONGSU + " - " + txtBD_Ten.Text + " - " + txtNoidungdon.Text, soluongkytu_noidung);
                        obj.TENVUVIEC = noidung_short;
                    }
                    else
                        obj.TENVUVIEC = ds.TENDUONGSU + " - " + txtBD_Ten.Text + " - " + dropQHPL.SelectedItem.Text;
                }
                else
                {
                    if (dropQHPL.SelectedValue == "0")
                    {
                        string noidung_short = Cls_Comon.CatXau(txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtNoidungdon.Text, soluongkytu_noidung);
                        obj.TENVUVIEC = noidung_short;
                    }
                    else
                        obj.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + dropQHPL.SelectedItem.Text;
                }
                
            }

            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = UserID;
                dt.DONKK_DON.Add(obj);
            }
            else
                obj.NGAYSUA = DateTime.Now;

            if (trangthai == 0)//Trạng thái gửi đơn, anhvh thêm trường ngày gủi
            {
                obj.NGAYGUI = DateTime.Now;
            }
            //-----------------------
            dt.SaveChanges();
            CurrDonID = obj.ID;
            hddDonKKID.Value = CurrDonID.ToString();
            #endregion

            //----------------------
            Update_DonKK_File(CurrDonID);

            //-------Update duong su cua donkhoikien------------
            Update_DonKK_DuongSu(CurrDonID, obj.MALOAIVUAN);
            //----------------------
            try
            {
                if (Status_DonKK == STATUS_BOSUNG)
                {
                    Decimal VuAnID = (Decimal)obj.VUANID;
                    String MaLoaiVuAN = hddLinhVucVuViec.Value;

                    UpdateAnTrongGSTP(obj);
                }

                if (trangthai == 0)
                {
                    //gui don
                    if (Status_DonKK != STATUS_BOSUNG)
                        GhiLog(ENUM_HD_NGUOIDUNG_DKK.GUIDONKKMOI, obj);
                    else
                        GhiLog(ENUM_HD_NGUOIDUNG_DKK.GUIBOSUNGDONKK, obj);
                }
                else if (trangthai == 10)
                {
                    //luu tam
                    GhiLog(ENUM_HD_NGUOIDUNG_DKK.SAVEDONKK, obj);
                }
            }
            catch (Exception ex) { }
        }
        #region Update file Don kk
        void Update_DonKK_File(Decimal DonKKID)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DKKUSERID == UserID
                                                                     && x.DONID == 0
                                                                     && x.TAILIEUID == 0).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                foreach (DONKK_DON_TAILIEU obj in lst)
                {
                    obj.DONID = DonKKID;
                }
                dt.SaveChanges();
            }
        }
        #endregion
        #region Update DonKK_DuongSu
        void Update_DonKK_DuongSu(Decimal DonKKID, String MaLoaiVuViec)
        {
            string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
            string CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal CurrUserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            //nếu không có ủy quyền
            if (rdUyQuyen.SelectedValue == "1")
            {
                try
                {
                    //--------update cac loai duong su nhap bang popup-----
                    List<DONKK_DON_DUONGSU> lstDS = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == 0
                                                                                && x.MALOAIVUVIEC == MaLoaiVuViec
                                                                                && x.NGUOITAOID == CurrUserID
                                                                              ).ToList<DONKK_DON_DUONGSU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (DONKK_DON_DUONGSU objDS in lstDS)
                        {
                            objDS.DONKKID = DonKKID;
                            dt.SaveChanges();
                        }
                    }
                }
                catch (Exception ex) { }
            }
            

            //---them moi DonKK_DuongSu (nguyendon dai dien/ Nguoi uy quyen, bidon dai dien)
            //cac duong su nay co DuongSuID =0
            if (rdUyQuyen.SelectedValue == "1")
                Update_DonKK_NguyenDon(DonKKID, MaLoaiVuViec, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            else
                Update_DonKK_NguyenDon(DonKKID, MaLoaiVuViec, "TGTTDS_01");

            Update_DonKK_BiDon(DonKKID, MaLoaiVuViec);
        }

        void Update_DonKK_NguyenDon(Decimal DonKKID, string MaLoaiVuviec, string MaTuCachToTung)
        {
            Boolean IsUpdate = false;
            string CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal CurrUserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            //string tucachtt_ma = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
            String ten_tucachtt = gsdt.DM_DATAITEM.Where(x => x.MA == MaTuCachToTung).SingleOrDefault().TEN;

            int Is_dai_dien = 0;
            DONKK_DON_DUONGSU oND = new DONKK_DON_DUONGSU();
            List<DONKK_DON_DUONGSU> lst = null;

            if (MaTuCachToTung == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON)
            {
                Is_dai_dien = 1;
                lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID
                                                    && x.ISDAIDIEN == 1
                                                    && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                    && x.NGUOITAOID == CurrUserID
                                                ).ToList<DONKK_DON_DUONGSU>();
                if (lst.Count > 0)
                {
                    IsUpdate = true;
                    oND = lst[0];
                }
                oND.MALOAIVUVIEC = MaLoaiVuviec;
                oND.DONKKID = DonKKID;
                oND.DUONGSUID = 0;

                oND.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTennguyendon.Text.Trim());
                oND.ISDAIDIEN = Is_dai_dien;
                oND.TUCACHTOTUNG_MA = MaTuCachToTung;
                oND.TUCACHTOTUNG = ten_tucachtt;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                oND.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;
                if (dropTinh_TamTru.SelectedValue == Value_NG)
                    oND.TAMTRUTINHID = oND.HKTTTINHID = oND.TAMTRUID = oND.HKTTID = 0;
                else
                {
                    oND.TAMTRUTINHID = oND.HKTTTINHID = Convert.ToDecimal(dropTinh_TamTru.SelectedValue);
                    oND.TAMTRUID = oND.HKTTID = Convert.ToDecimal(dropQuanHuyen_TamTru.SelectedValue);
                }
                oND.TAMTRUCHITIET = oND.HKTTCHITIET = txtND_TTChitiet.Text;
                oND.DIACHICOQUAN = txtND_DiaChiCoQuan.Text + "";

                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.NAMSINH = (String.IsNullOrEmpty(txtND_Namsinh.Text + "")) ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);

                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);


                oND.EMAIL = txtND_Email.Text;
                oND.DIENTHOAI = txtND_Dienthoai.Text;
                oND.FAX = txtND_Fax.Text;

                //-------Nguoi dai dien cua to chuc------------------
                oND.NDD_DIACHIID = Convert.ToDecimal(dropToChuc_QuanHuyen.SelectedValue);
                oND.NDD_DIACHICHITIET = txtToChuc_DiaChiCT.Text;
                oND.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;
                oND.NGUOIDAIDIEN = txtToChuc_NguoiDD.Text;

                //-----------------------
                oND.ISDON = 1;
                if (IsUpdate)
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = CurrUser;
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = CurrUser;
                    oND.NGUOITAOID = CurrUserID;
                    dt.DONKK_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }
            }
            else
            {
                //nếu là ủy quyền
                //Is_dai_dien = 0;
                lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID
                                                    && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                                                    && x.NGUOITAOID == CurrUserID
                                                  ).ToList<DONKK_DON_DUONGSU>();
                string strLstDuongSuId = "";
                string strLstTenDuongSu = "";
                List<DONKK_DON_DUONGSU_TEMP> ListData = GetDataStoreSession();
                if (lst.Count>0)
                {
                    //update các bản ghi hiện tại
                    foreach (DONKK_DON_DUONGSU_TEMP item in ListData)
                    {
                        if (item.ID>0)
                        {
                            //update những bản ghi này
                            DONKK_DON_DUONGSU oDuongSu = dt.DONKK_DON_DUONGSU.FirstOrDefault(s => s.ID == item.ID);
                            oDuongSu.DONKKID = DonKKID;
                            oDuongSu.ISDON = item.ISDON;
                            oDuongSu.DUONGSUID = item.DUONGSUID;
                            oDuongSu.STOPVB = item.STOPVB;
                            oDuongSu.TENDUONGSU = item.TENDUONGSU;
                            oDuongSu.ISDAIDIEN = item.ISDAIDIEN;
                            oDuongSu.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                            oDuongSu.ISDAIDIEN = item.ISDAIDIEN;

                            oDuongSu.LOAIDUONGSU = item.LOAIDUONGSU;
                            oDuongSu.SOCMND = item.SOCMND;
                            oDuongSu.QUOCTICHID = item.QUOCTICHID;

                            oDuongSu.NGAYSINH = item.NGAYSINH;
                            oDuongSu.THANGSINH = item.THANGSINH;
                            oDuongSu.NAMSINH = item.NAMSINH;
                            oDuongSu.GIOITINH = item.GIOITINH;
                            oDuongSu.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                            oDuongSu.CHUCVU = item.CHUCVU;
                            oDuongSu.EMAIL = item.EMAIL;
                            oDuongSu.DIENTHOAI = item.DIENTHOAI;
                            oDuongSu.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;
                            oDuongSu.FAX = item.FAX;
                            oDuongSu.TAMTRUTINHID = item.TAMTRUTINHID;
                            oDuongSu.HKTTTINHID = item.HKTTTINHID;
                            oDuongSu.TAMTRUID = item.TAMTRUID;
                            oDuongSu.HKTTID = item.HKTTID;
                            oDuongSu.TAMTRUCHITIET = item.TAMTRUCHITIET;
                            oDuongSu.HKTTCHITIET = item.HKTTCHITIET;
                            oDuongSu.DIACHICOQUAN = item.DIACHICOQUAN;
                            oDuongSu.NDD_DIACHIID = item.NDD_DIACHIID;

                            oDuongSu.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                            oDuongSu.TUCACHTOTUNG = item.TUCACHTOTUNG;
                            oDuongSu.MALOAIVUVIEC = item.MALOAIVUVIEC;
                            oDuongSu.NGAYTAO = item.NGAYTAO;
                            oDuongSu.NGUOITAO = item.NGUOITAO;
                            oDuongSu.NGUOITAOID = item.NGUOITAOID;
                            oDuongSu.NGAYSUA = item.NGAYSUA;
                            oDuongSu.NGUOISUA = item.NGUOISUA;
                            strLstDuongSuId += oDuongSu.ID + ",";
                            strLstTenDuongSu += oDuongSu.TENDUONGSU + ",";
                            dt.SaveChanges();
                        }
                    }

                    //xóa nhưngx bản ghi không có
                    foreach (var item in lst)
                    {
                        if (ListData.Count(s=>s.ID==item.ID)==0)
                        {
                            dt.DONKK_DON_DUONGSU.Remove(item);
                            dt.SaveChanges();
                        }
                    }
                }



                
                //lưu danh sách người ủy quyền
                
                foreach (DONKK_DON_DUONGSU_TEMP item in ListData)
                {
                    if (item.ID==0)
                    {
                        DONKK_DON_DUONGSU oDuongSu = new DONKK_DON_DUONGSU();
                        oDuongSu.DONKKID = DonKKID;
                        oDuongSu.ISDON = item.ISDON;
                        oDuongSu.DUONGSUID = item.DUONGSUID;
                        oDuongSu.STOPVB = item.STOPVB;
                        oDuongSu.TENDUONGSU = item.TENDUONGSU;
                        oDuongSu.ISDAIDIEN = item.ISDAIDIEN;
                        oDuongSu.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                        oDuongSu.ISDAIDIEN = item.ISDAIDIEN;

                        oDuongSu.LOAIDUONGSU = item.LOAIDUONGSU;
                        oDuongSu.SOCMND = item.SOCMND;
                        oDuongSu.QUOCTICHID = item.QUOCTICHID;

                        oDuongSu.NGAYSINH = item.NGAYSINH;
                        oDuongSu.THANGSINH = item.THANGSINH;
                        oDuongSu.NAMSINH = item.NAMSINH;
                        oDuongSu.GIOITINH = item.GIOITINH;
                        oDuongSu.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                        oDuongSu.CHUCVU = item.CHUCVU;
                        oDuongSu.EMAIL = item.EMAIL;
                        oDuongSu.DIENTHOAI = item.DIENTHOAI;
                        oDuongSu.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;
                        oDuongSu.FAX = item.FAX;
                        oDuongSu.TAMTRUTINHID = item.TAMTRUTINHID;
                        oDuongSu.HKTTTINHID = item.HKTTTINHID;
                        oDuongSu.TAMTRUID = item.TAMTRUID;
                        oDuongSu.HKTTID = item.HKTTID;
                        oDuongSu.TAMTRUCHITIET = item.TAMTRUCHITIET;
                        oDuongSu.HKTTCHITIET = item.HKTTCHITIET;
                        oDuongSu.DIACHICOQUAN = item.DIACHICOQUAN;
                        oDuongSu.NDD_DIACHIID = item.NDD_DIACHIID;

                        oDuongSu.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                        oDuongSu.TUCACHTOTUNG = item.TUCACHTOTUNG;
                        oDuongSu.MALOAIVUVIEC = item.MALOAIVUVIEC;
                        oDuongSu.NGAYTAO = item.NGAYTAO;
                        oDuongSu.NGUOITAO = item.NGUOITAO;
                        oDuongSu.NGUOITAOID = item.NGUOITAOID;
                        oDuongSu.NGAYSUA = item.NGAYSUA;
                        oDuongSu.NGUOISUA = item.NGUOISUA;
                        dt.DONKK_DON_DUONGSU.Add(oDuongSu);
                        dt.SaveChanges();
                        strLstDuongSuId += oDuongSu.ID + ",";
                        strLstTenDuongSu += oDuongSu.TENDUONGSU + ",";
                    }
                    
                }
                strLstDuongSuId = "," + strLstDuongSuId;

                //kiểm tra người tham gia tố tụng có có hay không
                List<DONKK_DON_THAMGIATOTUNG> lstNguoithamgiatotung = dt.DONKK_DON_THAMGIATOTUNG.Where(s => s.DONKKID == DonKKID).ToList();
                if (lstNguoithamgiatotung.Count>0)
                {

                       DONKK_DON_THAMGIATOTUNG oDONKK = lstNguoithamgiatotung[0];
                    oDONKK.DONKKID = DonKKID;
                    oDONKK.HOTEN = Cls_Comon.FormatTenRieng(txtTennguyendon.Text.Trim());
                    oDONKK.DUONGSUID = strLstDuongSuId;
                    oDONKK.TENDUONGSU = strLstTenDuongSu;

                    oDONKK.MALOAIVUVIEC = MaLoaiVuviec;

                    oDONKK.THANGSINH = 0;
                    oDONKK.TUCACHTOTUNG = MaTuCachToTung;

                    oDONKK.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    oDONKK.SOCMND = txtND_CMND.Text;
                    oDONKK.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    oDONKK.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;
                    if (dropTinh_TamTru.SelectedValue == Value_NG)
                        oDONKK.TAMTRUTINHID = oDONKK.HKTTTINHID = oDONKK.TAMTRUID = oDONKK.HKTTID = 0;
                    else
                    {
                        oDONKK.TAMTRUTINHID = oDONKK.HKTTTINHID = Convert.ToDecimal(dropTinh_TamTru.SelectedValue);
                        oDONKK.TAMTRUID = oDONKK.HKTTID = Convert.ToDecimal(dropQuanHuyen_TamTru.SelectedValue);
                    }
                    oDONKK.TAMTRUCHITIET = oDONKK.HKTTCHITIET = txtND_TTChitiet.Text;
                    oDONKK.DIACHICOQUAN = txtND_DiaChiCoQuan.Text + "";

                    DateTime? dNDNgaysinh;
                    dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oDONKK.NGAYSINH = dNDNgaysinh;
                    oDONKK.NAMSINH = (String.IsNullOrEmpty(txtND_Namsinh.Text + "")) ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);

                    oDONKK.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);


                    oDONKK.EMAIL = txtND_Email.Text;
                    oDONKK.DIENTHOAI = txtND_Dienthoai.Text;
                    oDONKK.FAX = txtND_Fax.Text;

                    //-------Nguoi dai dien cua to chuc------------------
                    oDONKK.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;

                    
                        oDONKK.NGAYSUA = DateTime.Now;
                        oDONKK.NGUOISUA = CurrUser;
                        dt.SaveChanges();


                    SetDataStoreSession(null);
                    Thongtinnguoiuyquyen.LoadGrid();
                }
                else
                {
                    DONKK_DON_THAMGIATOTUNG oDONKK = new DONKK_DON_THAMGIATOTUNG();
                    oDONKK.DONKKID = DonKKID;
                    oDONKK.HOTEN = Cls_Comon.FormatTenRieng(txtTennguyendon.Text.Trim());
                    oDONKK.DUONGSUID = strLstDuongSuId;
                    oDONKK.TENDUONGSU = strLstTenDuongSu;

                    oDONKK.MALOAIVUVIEC = MaLoaiVuviec;

                    oDONKK.THANGSINH = 0;
                    oDONKK.TUCACHTOTUNG = MaTuCachToTung;

                    oDONKK.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    oDONKK.SOCMND = txtND_CMND.Text;
                    oDONKK.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    oDONKK.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;
                    if (dropTinh_TamTru.SelectedValue == Value_NG)
                        oDONKK.TAMTRUTINHID = oDONKK.HKTTTINHID = oDONKK.TAMTRUID = oDONKK.HKTTID = 0;
                    else
                    {
                        oDONKK.TAMTRUTINHID = oDONKK.HKTTTINHID = Convert.ToDecimal(dropTinh_TamTru.SelectedValue);
                        oDONKK.TAMTRUID = oDONKK.HKTTID = Convert.ToDecimal(dropQuanHuyen_TamTru.SelectedValue);
                    }
                    oDONKK.TAMTRUCHITIET = oDONKK.HKTTCHITIET = txtND_TTChitiet.Text;
                    oDONKK.DIACHICOQUAN = txtND_DiaChiCoQuan.Text + "";

                    DateTime? dNDNgaysinh;
                    dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oDONKK.NGAYSINH = dNDNgaysinh;
                    oDONKK.NAMSINH = (String.IsNullOrEmpty(txtND_Namsinh.Text + "")) ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);

                    oDONKK.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);


                    oDONKK.EMAIL = txtND_Email.Text;
                    oDONKK.DIENTHOAI = txtND_Dienthoai.Text;
                    oDONKK.FAX = txtND_Fax.Text;

                    //-------Nguoi dai dien cua to chuc------------------
                    oDONKK.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;

                    
                        oDONKK.NGAYTAO = DateTime.Now;
                        oDONKK.NGUOITAO = CurrUser;
                        oDONKK.NGUOITAOID = CurrUserID;
                        dt.DONKK_DON_THAMGIATOTUNG.Add(oDONKK);
                        dt.SaveChanges();
                    
                    SetDataStoreSession(null);
                    Thongtinnguoiuyquyen.LoadGrid();
                }
                
            }

        }
        void Update_DonKK_BiDon(Decimal DonKKID, String MaLoaiVuViec)
        {
            #region "người khởi kiện ĐẠI DIỆN"
            Boolean IsUpdate = false;
            string tucachtt_ma = ENUM_DANSU_TUCACHTOTUNG.BIDON;
            String ten_tucachtt = gsdt.DM_DATAITEM.Where(x => x.MA == tucachtt_ma).SingleOrDefault().TEN;
            string CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal CurrUserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            DONKK_DON_DUONGSU oBD = new DONKK_DON_DUONGSU();
            List<DONKK_DON_DUONGSU> lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID
                                                                        && x.ISDAIDIEN == 1
                                                                        && x.TUCACHTOTUNG_MA == tucachtt_ma
                                                                        && x.NGUOITAOID == CurrUserID
                                                                    ).ToList<DONKK_DON_DUONGSU>();
            if (lst.Count > 0)
            {
                IsUpdate = true;
                oBD = lst[0];
            }
            oBD.MALOAIVUVIEC = MaLoaiVuViec;
            oBD.DONKKID = DonKKID;
            oBD.DUONGSUID = 0;
            oBD.TENDUONGSU = Cls_Comon.FormatTenRieng(txtBD_Ten.Text.Trim());
            oBD.ISDAIDIEN = 1;

            oBD.TUCACHTOTUNG_MA = tucachtt_ma;
            oBD.TUCACHTOTUNG = ten_tucachtt;

            oBD.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
            oBD.SOCMND = txtBD_CMND.Text;
            oBD.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
            oBD.SINHSONG_NUOCNGOAI = chkBD_ONuocNgoai.Checked == true ? 1 : 0;
            if (dropBD_Tinh_TamTru.SelectedValue == Value_NG)
                oBD.TAMTRUTINHID = oBD.HKTTTINHID = oBD.TAMTRUID = oBD.HKTTID = 0;
            else
            {
                oBD.TAMTRUTINHID = oBD.HKTTTINHID = Convert.ToDecimal(dropBD_Tinh_TamTru.SelectedValue);
                oBD.TAMTRUID = oBD.HKTTID = Convert.ToDecimal(dropBD_QuanHuyen_TamTru.SelectedValue);
            }
            oBD.TAMTRUCHITIET = oBD.HKTTCHITIET = txtBD_Tamtru_Chitiet.Text;
            oBD.DIACHICOQUAN = txtBD_DiaChiCoQuan.Text + "";

            DateTime dBDNgaysinh;
            dBDNgaysinh = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oBD.NGAYSINH = dBDNgaysinh;
            oBD.NAMSINH = (string.IsNullOrEmpty(txtBD_Namsinh.Text.Trim())) ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);

            oBD.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
            oBD.EMAIL = txtBD_Email.Text;
            oBD.DIENTHOAI = txtBD_Dienthoai.Text;
            oBD.FAX = txtBD_Fax.Text;

            oBD.NDD_DIACHIID = Convert.ToDecimal(dropTochuc_BD_QuanHuyen.SelectedValue);
            oBD.NDD_DIACHICHITIET = txtToChuc_BD_DiaChiCT.Text;
            oBD.CHUCVU = txtBD_NDD_Chucvu.Text;
            oBD.NGUOIDAIDIEN = txtBD_NDD_ten.Text;

            oBD.ISDON = 1;
            if (IsUpdate)
            {
                oBD.NGAYSUA = DateTime.Now;
                oBD.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                oBD.NGAYTAO = DateTime.Now;
                oBD.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oBD.NGUOITAOID = CurrUserID;
                dt.DONKK_DON_DUONGSU.Add(oBD);
                dt.SaveChanges();
            }
            #endregion
        }
        #endregion

        //-------------------------------
        #region Update an trong GSTP
        void UpdateAnTrongGSTP(DONKK_DON objDon)
        {
            Decimal QLAn_VuAnID = (decimal)objDon.VUANID;
            String MaLoaiVuAn = objDon.MALOAIVUAN;
            switch (MaLoaiVuAn)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    Update_AnDanSu(QLAn_VuAnID, objDon);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Update_AHC(QLAn_VuAnID, objDon);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Update_AHN(QLAn_VuAnID, objDon);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Update_AKT(QLAn_VuAnID, objDon);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Update_ALD(QLAn_VuAnID, objDon);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Update_APS(QLAn_VuAnID, objDon);
                    break;
            }
        }
        void Update_AnDanSu(Decimal QLAn_VuAnID, DONKK_DON objDon)
        {
            try
            {
                ADS_DON oT = gsdt.ADS_DON.Where(x => x.ID == QLAn_VuAnID).FirstOrDefault();
                if (oT != null)
                {
                    oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                    oT.NGAYSUA = DateTime.Now;
                    gsdt.SaveChanges();
                }
                //-----------------------------
                Decimal DonKKID = objDon.ID;
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                //Lưu duong su
                objBL.Update_QLAn_DuongSu(CurrUserName, QLAn_VuAnID, DonKKID, ENUM_LOAIAN.AN_DANSU);

                ADS_DON_DUONGSU_BL oDonBL = new ADS_DON_DUONGSU_BL();
                oDonBL.ADS_DON_YEUTONUOCNGOAI_UPDATE(QLAn_VuAnID);
                //-----------------------------
                objBL.Update_QLAn_TaiLieuBanGiao(CurrUserName, DonKKID, QLAn_VuAnID, ENUM_LOAIAN.AN_DANSU);
            }
            catch (Exception ex)
            {
            }
        }
        void Update_AHC(Decimal QLAn_VuAnID, DONKK_DON objDon)
        {
            try
            {
                AHC_DON oT = gsdt.AHC_DON.Where(x => x.ID == QLAn_VuAnID).FirstOrDefault();
                oT.LOAIQDHANHCHINHID = Convert.ToDecimal(objDon.LOAIQDHANHCHINHID);
                oT.SOQD = objDon.SOQD;
                DateTime date_temp = (String.IsNullOrEmpty(objDon.NGAYQD + "")) ? DateTime.MinValue : DateTime.Parse(objDon.NGAYQD + "", cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYQD = date_temp;
                oT.TENQD = objDon.TENQD;
                oT.HANHVIHC = objDon.HANHVIHC;
                //---------
                oT.QDHC_CUA = objDon.QDHC_CUA + "";
                oT.TOMTATHANHVIHCBIKIEN = objDon.TOMTATHANHVIHCBIKIEN + "";
                oT.NOIDUNGQUYETDINH = objDon.NOIDUNGQUYETDINH;
                //---------
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                gsdt.SaveChanges();

                //-----------------------------
                Decimal DonKKID = objDon.ID;
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                //Lưu duong su
                objBL.Update_QLAn_DuongSu(CurrUserName, QLAn_VuAnID, DonKKID, ENUM_LOAIAN.AN_HANHCHINH);

                AHC_DON_DUONGSU_BL oDonBL = new AHC_DON_DUONGSU_BL();
                oDonBL.AHC_DON_YEUTONUOCNGOAI_UPDATE(QLAn_VuAnID);
                //-----------------------------
                objBL.Update_QLAn_TaiLieuBanGiao(CurrUserName, DonKKID, QLAn_VuAnID, ENUM_LOAIAN.AN_HANHCHINH);

            }
            catch (Exception ex)
            {
            }
        }
        void Update_AHN(Decimal QLAn_VuAnID, DONKK_DON objDon)
        {
            try
            {
                AHN_DON oT = gsdt.AHN_DON.Where(x => x.ID == QLAn_VuAnID).FirstOrDefault();

                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                gsdt.SaveChanges();

                //-------Nguyen don , bi don
                Decimal DonKKID = objDon.ID;
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                //Lưu duong su
                objBL.Update_QLAn_DuongSu(CurrUserName, QLAn_VuAnID, DonKKID, ENUM_LOAIAN.AN_HONNHAN_GIADINH);

                //-----------------------------
                AHN_DON_DUONGSU_BL oDonBL = new AHN_DON_DUONGSU_BL();
                oDonBL.AHN_DON_YEUTONUOCNGOAI_UPDATE(QLAn_VuAnID);
                //-----------------------------
                objBL.Update_QLAn_TaiLieuBanGiao(CurrUserName, DonKKID, QLAn_VuAnID, ENUM_LOAIAN.AN_HONNHAN_GIADINH);
            }
            catch (Exception ex)
            {
            }
        }
        void Update_AKT(Decimal QLAn_VuAnID, DONKK_DON objDon)
        {
            try
            {
                AKT_DON oT = gsdt.AKT_DON.Where(x => x.ID == QLAn_VuAnID).FirstOrDefault();
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;

                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                gsdt.SaveChanges();
                //-----------------------------
                Decimal DonKKID = objDon.ID;
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                //Lưu duong su
                objBL.Update_QLAn_DuongSu(CurrUserName, QLAn_VuAnID, DonKKID, ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI);

                AKT_DON_DUONGSU_BL oDonBL = new AKT_DON_DUONGSU_BL();
                oDonBL.AKT_DON_YEUTONUOCNGOAI_UPDATE(QLAn_VuAnID);
                //-----------------------------
                objBL.Update_QLAn_TaiLieuBanGiao(CurrUserName, DonKKID, QLAn_VuAnID, ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI);
            }
            catch (Exception ex)
            { }
        }
        void Update_ALD(Decimal QLAn_VuAnID, DONKK_DON objDon)
        {
            try
            {
                ALD_DON oT = gsdt.ALD_DON.Where(x => x.ID == QLAn_VuAnID).FirstOrDefault();
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                gsdt.SaveChanges();

                //-----------------------------
                Decimal DonKKID = objDon.ID;
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                //Lưu duong su
                objBL.Update_QLAn_DuongSu(CurrUserName, QLAn_VuAnID, DonKKID, ENUM_LOAIAN.AN_LAODONG);

                //-----------------------------
                ALD_DON_DUONGSU_BL oDonBL = new ALD_DON_DUONGSU_BL();
                oDonBL.ALD_DON_YEUTONUOCNGOAI_UPDATE(QLAn_VuAnID);
                //-----------------------------
                objBL.Update_QLAn_TaiLieuBanGiao(CurrUserName, DonKKID, QLAn_VuAnID, ENUM_LOAIAN.AN_LAODONG);
            }
            catch (Exception ex)
            {
            }
        }
        void Update_APS(Decimal QLAn_VuAnID, DONKK_DON objDon)
        {
            try
            {
                APS_DON oT = gsdt.APS_DON.Where(x => x.ID == QLAn_VuAnID).FirstOrDefault();
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                gsdt.SaveChanges();
                //-----------------------------
                Decimal DonKKID = objDon.ID;
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                //Lưu duong su
                objBL.Update_QLAn_DuongSu(CurrUserName, QLAn_VuAnID, DonKKID, ENUM_LOAIAN.AN_PHASAN);
                //-----------------------------
                APS_DON_DUONGSU_BL oDonBL = new APS_DON_DUONGSU_BL();
                oDonBL.APS_DON_YEUTONUOCNGOAI_UPDATE(QLAn_VuAnID);

                objBL.Update_QLAn_TaiLieuBanGiao(CurrUserName, DonKKID, QLAn_VuAnID, ENUM_LOAIAN.AN_PHASAN);

            }
            catch (Exception ex)
            {
            }
        }

        #endregion



        protected void Load_ddlToaanID()
        {
            ddlToaanID.Items.Clear();
            ddlToaanID.DataSource = gsdt.DM_TOAAN.Where(x => x.CAPCHAID > 0 && x.HIEULUC == 1 && x.SOCAP >= 3 && x.LOAITOA != "CAPCAO" && x.NHANDKKONLINE == 1).OrderBy(y => y.THUTU).ToList();
            ddlToaanID.DataTextField = "TEN";
            ddlToaanID.DataValueField = "ID";
            ddlToaanID.DataBind();
            ddlToaanID.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

    }

}


