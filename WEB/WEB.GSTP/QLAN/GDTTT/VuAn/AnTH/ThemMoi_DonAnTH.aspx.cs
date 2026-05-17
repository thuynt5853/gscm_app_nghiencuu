using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using BL.GSTP.BANGSETGET;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.AnTH
{
    public partial class ThemMoi_DonAnTH : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        public decimal VuAnID = 0;
        public int nguoikhieunai = 2;
        public int bicao = 0;
        public int bcdauvu = 1;
        public String type = "";
        public decimal CurrNhomNSDID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            

            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            VuAnID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            //CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    pnTTV.Visible = true;
                    chkModify_TTV.Visible = false;
                    pnThemBian.Visible = false;
                    LoadComponent();
                    LoadAll_TTV();
                    if (Request["ID"] != null)
                    {
                        Hi_update.Value = Request["ID"] + "";
                        try
                        {
                            LoadInfoDon_VuAn();
                        }
                        catch (Exception ex) { }
                    }
                    //6624

                    if (hddVuAnID.Value != null)
                    {

                        try
                        {

                            LoadInfoVuAn();
                            if (ddlLoaiBA.SelectedValue == "0")
                            {
                                LoadDropToaST_Full_ST();//anhvh 14/11/2019
                            }

                          
                        }
                        catch (Exception ex) { }
                    }

                }
            }
            else Response.Redirect("/Login.aspx");
        }
        void LoadInfoDon_VuAn()
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(Hi_update.Value)) ? 0 : Convert.ToDecimal(Hi_update.Value + "");
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            DataTable tbl = null;
            tbl = oBL.Gdttt_Tuhinh_Don_GetByID(CurrDonID);
            if (tbl.Rows.Count > 0)
            {
                txtNguoigui.Text = tbl.Rows[0]["NGUOIGUI"] + "";
                txt_DiachiNguoigui.Text = tbl.Rows[0]["NGUOIGUI_DIACHI"] + "";
                ddlThamtravien.SelectedValue = tbl.Rows[0]["NGUOINHAN_ID"] + "";
                txtNgayghidon.Text = ((DateTime)tbl.Rows[0]["NGAYTRENDON"]).ToString("dd/MM/yyyy", cul);
                txtNgaynhandon.Text = ((DateTime)tbl.Rows[0]["NGAYNHAN"]).ToString("dd/MM/yyyy", cul);
                Drop_LOAI.SelectedValue = tbl.Rows[0]["LOAI"] + "";
                txtNoidung.Text = tbl.Rows[0]["NOIDUNG"] + "";
                hddVuAnID.Value = Convert.ToString(tbl.Rows[0]["VUANID"]);
                hddDuongSuID.Value = Convert.ToString(tbl.Rows[0]["DUONGSUID"]);
                hddHOSO_ANGIAM_ID.Value = Convert.ToString(tbl.Rows[0]["hosoid"]);

                if (hddVuAnID.Value!="0")
                    hhdcheckDS.Value = "1";
            }
        }
        void LoadInfoVuAn()
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single();
            if (obj != null)
            {

                //Loai BA GDT

                if (obj.BAQD_CAPXETXU == 4)
                {
                    hddIsAnPT.Value = "GDT";
                    pnQDGDT.Visible = pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAnGDT(dropToaGDT);
                    if (obj.TOAQDID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaGDT, obj.TOAQDID);
                        LoadDropToaPT_TheoGDT(Convert.ToDecimal(obj.TOAQDID));
                    }
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }
                else if (obj.BAQD_CAPXETXU == 3)
                {
                    hddIsAnPT.Value = "PT";
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAn(dropToaAn);
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }
                else if (obj.BAQD_CAPXETXU == 2)
                {
                    hddIsAnPT.Value = "ST";
                    pnQDGDT.Visible = pnPhucTham.Visible = false;
                    pnAnST.Visible = true;
                    LoadDropToaST_Full();
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);

                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;
                }
                else
                {
                    hddIsAnPT.Value = "PT";
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAn(dropToaAn);
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }

                if (obj.BAQD_CAPXETXU != null)
                    Cls_Comon.SetValueComboBox(ddlLoaiBA, obj.BAQD_CAPXETXU);

                txtSoQĐGDT.Text = obj.SO_QDGDT;
                txtNgayGDT.Text = (String.IsNullOrEmpty(obj.NGAYQD + "") || (obj.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul);

                txtSoBA.Text = obj.SOANPHUCTHAM + "";
                txtNgayBA.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);


                txtSoBA_ST.Text = obj.SOANSOTHAM;
                txtNgayBA_ST.Text = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);

                //---------thong tin BA/QD----------------------

                //Decimal ToaAnID = 0;
                //int IsAnPT = 0;
                ////hddIsAnPT
                //try
                //{
                //    Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                //    if (dropToaAn.SelectedValue != "0")
                //        IsAnPT++;
                //    ToaAnID = (string.IsNullOrEmpty(obj.TOAPHUCTHAMID + "")) ? 0 : (Decimal)obj.TOAPHUCTHAMID;
                //    if (ToaAnID > 0)
                //        IsAnPT++;
                //}
                //catch (Exception ex) { }
                //txtSoBA.Text = obj.SOANPHUCTHAM + "";
                //if (!String.IsNullOrEmpty(obj.SOANPHUCTHAM + ""))
                //    IsAnPT++;
                //txtNgayBA.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                //if (String.IsNullOrEmpty(txtNgayBA.Text))
                //    IsAnPT++;
                //if (IsAnPT > 0)
                //{
                //    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                //    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;

                //}
                //else { lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false; }

                //pnAnST.Visible = false;
                //if (ToaAnID > 0)
                //{
                //    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                //    DM_TOAAN objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                //    if (objTA != null)
                //    {

                //        pnAnST.Visible = true;
                //        LoadBanAnST(obj);

                //    }
                //}
                //else
                //{
                //    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                //    String ngayba = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                //    ToaAnID = (string.IsNullOrEmpty(obj.TOAANSOTHAM + "")) ? 0 : (Decimal)obj.TOAANSOTHAM;
                //    if (!String.IsNullOrEmpty(obj.SOANSOTHAM) || ToaAnID > 0 || (!string.IsNullOrEmpty(ngayba)))
                //    {

                //        lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;
                //        pnAnST.Visible = true;
                //        LoadBanAnST(obj);
                //    }
                //    else lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                //}
                //if ((obj.SOANPHUCTHAM + "") != "")
                //{
                //    pnPhucTham.Visible = true;
                //    pnAnST.Visible = true;
                //    ddlLoaiBA.SelectedValue = "1";
                //}
                //else
                //{
                //    pnPhucTham.Visible = false;
                //    pnAnST.Visible = true;
                //    ddlLoaiBA.SelectedValue = "0";
                //}
                //----------thong tin Bi an--------------------

                decimal duongsuid = Convert.ToDecimal(hddDuongSuID.Value);
                
                GDTTT_TUHINH_BL objds = new GDTTT_TUHINH_BL();
                DataTable tbl;
                tbl = objds.GDTTT_VUAN_GETALLDUONGSU(CurrDonID, duongsuid);
                dgListDuongSu.DataSource = tbl;
                dgListDuongSu.DataBind();

               //----------thong tin TTV/LD---------------------
                LoadnInfo_TTV_LD_TP(obj);
            }
        }

        void LoadBanAnST(GDTTT_VUAN obj)
        {
            try
            {
                LoadDropToaST_TheoPT();
            }
            catch (Exception ex) { LoadDropToaAn(dropToaAnST); }
            try { Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM); } catch (Exception ex) { }
            txtSoBA_ST.Text = obj.SOANSOTHAM + "";
            txtNgayBA_ST.Text = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
        }
        void LoadnInfo_TTV_LD_TP(GDTTT_VUAN obj)
        {
            int show_form = 0;
            txtNgayphancong.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
            txtNgayNhanTieuHS.Text = (String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);
            if (!string.IsNullOrEmpty(txtNgayphancong.Text))
                show_form++;

            decimal tempID = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
            if (tempID > 0)
            {
                try
                {
                    Cls_Comon.SetValueComboBox(dropTTV, tempID);
                    chkModify_TTV.Visible = true;
                    dropTTV.Enabled = false;
                }
                catch (Exception ex) { }
                show_form++;
                GetAllLanhDaoNhanBCTheoTTV(tempID);
            }
            //-------------------------------
           
            try
            {
                tempID = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
                if (tempID > 0)
                {
                    show_form++;
                    Cls_Comon.SetValueComboBox(dropLanhDao, tempID);
                    dropLanhDao.Enabled = false;
                }
            }
            catch (Exception ex) { }
            //--------------
            
            //tempID = (String.IsNullOrEmpty(obj.HOSOID + "")) ? 0 : Convert.ToDecimal(obj.HOSOID);
            if (obj.ISHOSO > 0)
            {
                GDTTT_QUANLYHS objHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == obj.ID && x.LOAI == "3" ).FirstOrDefault();
                if (objHS != null)
                    txtNgayNhanHS.Text = (String.IsNullOrEmpty(objHS.NGAYTAO + "") || (objHS.NGAYTAO == DateTime.MinValue)) ? "" : ((DateTime)objHS.NGAYTAO).ToString("dd/MM/yyyy", cul);
            }
            //-------------------------------
            
            try
            {
                tempID = (String.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : Convert.ToDecimal(obj.THAMPHANID);
                if (tempID > 0)
                {
                    show_form++;
                    Cls_Comon.SetValueComboBox(dropThamPhan, tempID);
                    dropThamPhan.Enabled = false;
                }
                else dropThamPhan.Enabled = true;
            }
            catch (Exception ex) { dropThamPhan.Enabled = true; }

            //-------------------------------
            txtGhiChu.Text = obj.GHICHU;
            if (!string.IsNullOrEmpty(txtGhiChu.Text))
                show_form++;
            //-------------------------------
            if (show_form > 0)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                //Session[SessionTTV] = "0";
            }
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox curr_chk = (CheckBox)sender;
        
            if (curr_chk.Checked)
            {
                dropTTV.Enabled = true;
                dropLanhDao.Enabled = true;

            }
            else
            {
                dropTTV.Enabled = false;
                dropLanhDao.Enabled = false;
            }
        }
     


        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("DanhSachDonAnTH.aspx");
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            GDTTT_TUHINH_DON obj = new GDTTT_TUHINH_DON();
            string Mess_Check = "Đã thêm mới thành công";
            ///-----------------------------
            if (Hi_update.Value != "0")
            {
                Mess_Check = "Đã cập nhật thành công";
            }
            obj.ID = Convert.ToInt32(Hi_update.Value);
            obj.VUANID = Convert.ToInt32(hddVuAnID.Value);

            obj.DUONGSUID = Convert.ToInt32(hddDuongSuID.Value);
            if (hddHOSO_ANGIAM_ID.Value != "")
                obj.HOSO_ANGIAM_ID = Convert.ToInt32(hddHOSO_ANGIAM_ID.Value);
            else
                obj.HOSO_ANGIAM_ID = 0;

            obj.NGUOIGUI = txtNguoigui.Text;
            obj.NGUOIGUI_DIACHI = txt_DiachiNguoigui.Text;
            if (ddlThamtravien.SelectedValue != "")
            {
                obj.NGUOINHAN_ID = Convert.ToInt32(ddlThamtravien.SelectedValue);
            }
            
            obj.NGAYTRENDON = DateTime.Parse(this.txtNgayghidon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYNHAN = DateTime.Parse(this.txtNgaynhandon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.LOAI = Convert.ToInt32(Drop_LOAI.SelectedValue);
            obj.NOIDUNG = txtNoidung.Text;
            obj.NGUOITAO_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            obj.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            obj.TENBIAN = txtBC_HoTen.Text;
            obj.NAMSINH = Convert.ToDecimal(ddlNamsinh.SelectedValue);
            obj.DIACHI = txtDiachi.Text;
            obj.TOIDANH_ID = Convert.ToDecimal(dropBiCao_ToiDanh.SelectedValue);
            obj.TENTOIDANH = Convert.ToString(dropBiCao_ToiDanh.SelectedItem.Text);


            obj.CAPXX_ID = Convert.ToDecimal(ddlLoaiBA.SelectedValue);

            obj.SO_BA = txtSoBA.Text;
            if (!String.IsNullOrWhiteSpace(txtNgayBA.Text))
                obj.NGAY_BA = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.TOAXX_ID = Convert.ToInt32(dropToaAn.SelectedValue);

            if (!String.IsNullOrWhiteSpace(txtSoBA_ST.Text))
                obj.SO_BAST = txtSoBA_ST.Text;
            if (!String.IsNullOrWhiteSpace(txtNgayBA_ST.Text))
                obj.NGAY_BAST = DateTime.Parse(this.txtNgayBA_ST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.TOAXXST_ID = Convert.ToInt32(dropToaAnST.SelectedValue);
            if (txtNgayphancong.Text != "")
                obj.NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dropTTV.SelectedValue != "0")
            {
                obj.THAMTRAVIENID = Convert.ToInt32(dropTTV.SelectedValue);
                obj.TENTHAMTRAVIEN = dropTTV.SelectedItem.Text;
            }
                
            if (txtNgayNhanTieuHS.Text != "")
                obj.NgayNhanTieuHS = DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (txtNgayNhanHS.Text != "")
                obj.NgayNhanHS = DateTime.Parse(this.txtNgayNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            
            obj.LANHDAOVU = Convert.ToInt32(dropLanhDao.SelectedValue);
            obj.THAMPHAN = Convert.ToInt32(dropThamPhan.SelectedValue);



           GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            if (oBL.Gdttt_Tuhinh_Don_Insert_Update(obj) == true)
            {
                lttMsgT.Text = Mess_Check;
                Response.Redirect("DanhSachDonAnTH.aspx");
            }
        }
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm();
        }
        void ClearForm()
        {

        }
        protected void ddlThamtravien_SelectedIndexChanged(object sender, EventArgs e)
        {

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
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", ""));
        }

        void LoadDropToaST_Full()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //anhvh 14/11/2019
        void LoadDropToaST_Full_ST()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR_ST();
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadComponent()
        {
            LoadDropToaAnGDT(dropToaGDT);
            LoadDropToaAn(dropToaAn);
            //LoadLoaiAnTheoVu();
            LoadDropToiDanh(dropBiCao_ToiDanh);
            try
            {
                LoadDropLanhDao();
                LoadDropTTV();
                LoadThamPhan();
                LoadDropNamSinh(ddlNamsinh);
            }
            catch (Exception ex) { }
            // hddGUID.Value = Guid.NewGuid().ToString();
        }
        protected void LoadThamPhan()
        {
            dropThamPhan.Items.Clear();
            Boolean IsLoadAll = false;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        dropThamPhan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dropThamPhan.DataSource = tbl;
                    dropThamPhan.DataValueField = "ID";
                    dropThamPhan.DataTextField = "Hoten";
                    dropThamPhan.DataBind();
                    dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
        }
        void LoadDropLanhDao()
        {
            dropLanhDao.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                dropLanhDao.DataSource = tblLanhDao;
                dropLanhDao.DataValueField = "ID";
                dropLanhDao.DataTextField = "MA_TEN";
                dropLanhDao.DataBind();
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropTTV()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "TenCanBo";
                dropTTV.DataBind();
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
        }

        private void LoadDropToiDanh(DropDownList dropToiDanh)
        {
            string session_name = "HS_DropToiDanh";
            dropToiDanh.Items.Clear();
            GDTTT_APP_BL oBL = new GDTTT_APP_BL();
            DataTable tbl = new DataTable();
            //-------------
            tbl = oBL.DieuLuat_ToiDanh_Thongke();
            if (Session[session_name] == null)
            {
                tbl = oBL.DieuLuat_ToiDanh_Thongke();
                Session[session_name] = tbl;
            }
            else
                tbl = (DataTable)(Session[session_name]);

            dropToiDanh.DataSource = tbl;
            dropToiDanh.DataTextField = "TENTOIDANH";
            dropToiDanh.DataValueField = "ID";
            dropToiDanh.DataBind();
            dropToiDanh.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaAnGDT(DropDownList dropToaGDT)
        {
            dropToaGDT.Items.Clear();
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.CAPCHAID < 2 && x.HANHCHINHID != 0).OrderBy(y => y.CAPCHAID).ToList();
            dropToaGDT.DataSource = lst;
            dropToaGDT.DataTextField = "TEN";
            dropToaGDT.DataValueField = "ID";
            dropToaGDT.DataBind();
            dropToaGDT.Items.Insert(0, new ListItem("Chọn", "0"));
        }

        void LoadDropToaAn(DropDownList dropToaAn)
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaPT_TheoGDT(decimal ToaGDT_ID)
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaGDT.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaGDT_ID);
            dropToaAn.DataSource = tbl;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaST_TheoPT(decimal ToaPT_ID)
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaPT_ID);
            dropToaAnST.DataSource = tbl;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaST_TheoPT()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(CapChaID);
            dropToaAnST.DataSource = tbl;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }

        void LoadDropNamSinh(DropDownList ddlNamsinh)
        {
            ddlNamsinh.Items.Clear();
            int year = DateTime.Now.Year;
            for (int i = year; i >= year - 100; i--)
            {
                ListItem li = new ListItem(i.ToString());
                ddlNamsinh.Items.Add(li);
            }
            ddlNamsinh.Items.Insert(0, new ListItem("Chọn", "0"));
            //ddlNamsinh.Items.FindByText(year.ToString()).Selected = true;

        }
        protected void ddlLoaiBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBA.SelectedValue == "3")
            {
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                pnQDGDT.Visible = false;
                hddIsAnPT.Value = "PT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
            else if (ddlLoaiBA.SelectedValue == "2")//anhvh 14/11/2019
            {
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                hddIsAnPT.Value = "ST";
                LoadDropToaST_Full_ST();
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;

            }
            else if (ddlLoaiBA.SelectedValue == "4")
            {
                pnQDGDT.Visible = true;
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                hddIsAnPT.Value = "GDT";
            }
            else
            {
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_Full();
                hddIsAnPT.Value = "PT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
            

        }

        protected void dropToaGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            decimal toa_an_id = Convert.ToDecimal(dropToaGDT.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
                {
                    pnPhucTham.Visible = true;
                    pnAnST.Visible = true;
                    Cls_Comon.SetFocus(this, this.GetType(), lttBB_SoPT.ClientID);
                    LoadDropToaPT_TheoGDT(Convert.ToDecimal(toa_an_id));
                }
                else { dropToaAn.Items.Clear(); }
                string banan_gdt = txtSoQĐGDT.Text.Trim();
                if (!string.IsNullOrEmpty(banan_gdt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoQĐGDT.ClientID);
            }
            else
            {
                pnQDGDT.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaGDT.ClientID);
                dropToaGDT.Items.Clear();
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }
        }

        //----------------------------------------
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            hddInputAnST.Value = "0";
            decimal toa_an_id = Convert.ToDecimal(dropToaAn.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
                {
                    pnAnST.Visible = true;
                    hddInputAnST.Value = "1";
                    Cls_Comon.SetFocus(this, this.GetType(), txtSoBA_ST.ClientID);
                    LoadDropToaST_TheoPT(toa_an_id);
                }
                else { dropToaAnST.Items.Clear(); }
                string banan_pt = txtSoBA.Text.Trim();
                if (!string.IsNullOrEmpty(banan_pt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoBA.ClientID);

            }
            else
            {
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }

        }
        protected void lkThemDSAnHS_Click(object sender, EventArgs e)
        {
            pnThemBian.Visible = true;
            hddDuongSuID.Value = "0";
            pnBanan.Visible = false;
            pnDSBian.Visible = false;
            //Them bị án mới 
            hhdcheckDS.Value = "1";
        }


        protected void lkTTV_Click(object sender, EventArgs e)
        {
            if (pnTTV.Visible == false)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                //Session[SessionTTV] = "0";
            }
            else
            {
                lkTTV.Text = "[ Mở ]";
                pnTTV.Visible = false;
                //Session[SessionTTV] = "1";
            }
        }
        protected void dropTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
        }
        void GetAllLanhDaoNhanBCTheoTTV(Decimal ThamTraVienID)
        {
            LoadDropLanhDao();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            if (ThamTraVienID > 0)
            {
                DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PhongBanID, ThamTraVienID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strLDVID = tbl.Rows[0]["ID"] + "";
                    dropLanhDao.SelectedValue = strLDVID;
                }
            }
        }
        //-------------------------------------------
        protected void cmdCheckVuAn_Click(object sender, EventArgs e)
        {
            String SoBA;
            DateTime NgayBA;
            Decimal ToaXX;
            Decimal vddlLoaiBA = Convert.ToDecimal(ddlLoaiBA.SelectedValue);
            if (vddlLoaiBA == 4)
            {
                SoBA = txtSoQĐGDT.Text;
                NgayBA = DateTime.Parse(this.txtNgayGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                ToaXX = Convert.ToDecimal(dropToaGDT.SelectedValue);
            }
            else if (vddlLoaiBA == 2)
            {
                SoBA = txtSoBA_ST.Text;
                NgayBA = DateTime.Parse(this.txtNgayBA_ST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                ToaXX = Convert.ToDecimal(dropToaAnST.SelectedValue);
            }
            else
            {
                SoBA = txtSoBA.Text;
                NgayBA = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                ToaXX = Convert.ToDecimal(dropToaAn.SelectedValue);
            }

            DataTable tbl = null;
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

            tbl = oBL.SearchDanhSachVuAn(SoBA, Convert.ToDateTime(NgayBA), Convert.ToDecimal(ToaXX), Convert.ToDecimal(vddlLoaiBA));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dgDsVuan.DataSource = tbl;
                dgDsVuan.DataBind();
                pnBanan.Visible = true;
            }else
                hhdcheckDS.Value = "1";

            //Session["ssddlLoaiBA"] = Convert.ToString(ddlLoaiBA.SelectedValue);

            //if (ddlLoaiBA.SelectedValue == "1")
            //{

            //    Session["ssSoBAPT"] = txtSoBA.Text;
            //    Session["ssNgayBA"] = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    Session["ssdropToaAn"] = Convert.ToDecimal(dropToaAn.SelectedValue); 
            //}
            //else
            //{
            //    Session["ssSoBAST"]  = txtSoBA_ST.Text;
            //    Session["ssNgayBAST"] = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    Session["ssdropToaAnST"]  = Convert.ToDecimal(dropToaAnST.SelectedValue); 
            //}
            //ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "script", "<script type='text/javascript'>ShowPopUp_Vuan();</script>", false);


            //ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "CheckVuAn", CheckVuAn, true);
            //CheckVuAn


        }
        protected void dgDsVuan_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

        }
        protected void dgDsVuan_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Select":
                    hddVuAnIDchon.Value = e.CommandArgument.ToString();
                    hddVuAnID.Value = e.CommandArgument.ToString();
                    hddDuongSuID.Value = "0";
                    pnBanan.Visible = false;
                    pnDSBian.Visible = true;
                    pnThemBian.Visible = false;
                    LoadInfoVuAn();
                    break;
            };
        }

        protected void dgListDuongSu_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Select":
                    string[] arrListStr = e.CommandArgument.ToString().Split('#');
                    hddDuongSuID.Value = arrListStr[0];
                    hddVuAnID.Value = arrListStr[1];
                    LoadInfoVuAn();
                    hhdcheckDS.Value = "3";// đã chọn bị án
                    break;
            };
        }
        protected void dgListDuongSu_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            //-------------------------------
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {

                decimal duongsuid = Convert.ToDecimal(hddDuongSuID.Value);
                Button cmdChitiet = (Button)e.Item.FindControl("cmdChitiet");
                if (duongsuid > 0)
                {
                    cmdChitiet.Visible = false;
                }
                else
                {
                    cmdChitiet.Visible = true;
                }
            }
        }
    }
}