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
using System.IO;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pKetQuaHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        String temp_folder_upload = "~/TempUpload/";
        Decimal LoaiNguoiKhangNghiID = 1143;//ChanhAn
        Decimal CurrentUserID = 0, CurrDonViID = 0;
        public String IsShowCol = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    if (loaitoa.Contains("cấp cao"))
                        lbl_GQD_NgayCV.Text = "Ngày phát hành của Phòng";
                    else
                        lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";

                    LoadDropDonThuLyMoi(null);
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";

                    if (Request["vid"] != null)
                        LoadInfoVuAn();
                }
            }
        }
        void LoadDropThamQuyenXX()
        {
            //Thẩm quyền xét xử
            ddlThamquyenXX.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                ddlThamquyenXX.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "TOICAO" || x.ID == CurrDonViID) && x.HIEULUC == 1 && x.HANHCHINHID > 0).OrderBy(x => x.ARRTHUTU).ToList();
            }
            else
                ddlThamquyenXX.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "TOICAO" || x.LOAITOA == "CAPCAO") && x.HIEULUC == 1 && x.HANHCHINHID > 0).OrderBy(x => x.ARRTHUTU).ToList();
            ddlThamquyenXX.DataTextField = "TEN";
            ddlThamquyenXX.DataValueField = "ID";
            ddlThamquyenXX.DataBind();
            ddlThamquyenXX.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void LoadDropNguoiKy(DropDownList drop, DataTable tbl)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (tbl == null)
                tbl = objBL.DM_CANBO_GETBYDONVI_2CHUCVU(donviID, ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadDropNguoiKyTP(DropDownList drop, DataTable tbl)//anhpn
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (tbl == null)
            {
                if (donviID == 1)
                {
                    tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHANTOICAO);
                    DataTable tpb3 = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN_BAC3); //lấy thêm TP bậc 3
                    tbl.Merge(tpb3);
                    tbl.AcceptChanges();
                }
                else
                {
                    tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                }
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadInfoVuAn()
        {
            try
            {
                decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                LoadThongTinVuAn(VuAnID, oT);

                if (oT.GQD_LOAIKETQUA != null)
                {
                    cmdXoa.Visible = true;
                    dropTLD_NguoiKy_td.Visible = false;
                    dropKN_NguoiKy_td.Visible = false;
                    rdbLoai.SelectedValue = oT.GQD_LOAIKETQUA.ToString();
                    string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    if (loaitoa.Contains("cấp cao"))
                        lbl_GQD_NgayCV.Text = "Ngày phát hành của Phòng";
                    else
                        lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";
                    pnXuLyKhac.Visible = false;
                    //rdbLoai.Enabled = false;
                    pnDon.Visible = false;
                    switch (oT.GQD_LOAIKETQUA.ToString())
                    {
                        case "0":
                            pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
                            pnTLD.Visible = true;
                            pnDon.Visible = true;
                            rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                            break;
                        case "1":
                            pnDon.Visible = true;
                            LoadDropThamQuyenXX();
                            pnQDKN.Visible = true;
                            pnVKS_GQ.Visible = pnXuLyKhac.Visible = pnTLD.Visible = pnXepDon.Visible = false;
                            txtSoQD.Text = oT.GDQ_SO + "";
                            txtKN_NguoiKy.Text = oT.GDQ_NGUOIKY + "";
                            if (oT.GDQ_NGAY != null) txtNgayQD.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            if (oT.THAMQUYENXXGDT != null) ddlThamquyenXX.SelectedValue = oT.THAMQUYENXXGDT + "";
                            rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                            break;
                        case "2":
                            pnVKS_GQ.Visible = pnQDKN.Visible = false;
                            pnTLD.Visible = false;
                            pnXepDon.Visible = true;
                            txtNguoiDuyetXepDon.Text = oT.GDQ_NGUOIKY + "";
                            txtSoXepDon.Text = oT.GDQ_SO + "";
                            txtNgayXepDon.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                            break;
                        case "3":
                            pnXuLyKhac.Visible = true;
                            pnVKS_GQ.Visible = pnTLD.Visible = pnXepDon.Visible = pnQDKN.Visible = false;
                            lbl_GQD_NgayCV.Text = "Ngày xử lý";
                            txtNoiDung_xlk.Text = oT.GQD_KETQUA;
                            txtKN_NguoiKy_xlk.Text = oT.GDQ_NGUOIKY + "";
                            rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[4].Enabled = false;
                            txt_xlk_so.Text = oT.GDQ_SO + "";
                            break;
                        case "4":
                            pnTLD.Visible = pnQDKN.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
                            pnVKS_GQ.Visible = true;
                            txtTB_So.Text = oT.GDQ_SO + "";
                            txtTB_NguoiKy.Text = oT.GDQ_NGUOIKY + "";
                            if (oT.GDQ_NGAY != null) txtTB_Ngay.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
                            break;
                    }
                    LoadDSTraLoiDon_AHS();
                    txtGhichu.Text = oT.GQD_GHICHU + "";
                }
                else
                {
                    txtTLD_NguoiKy_td.Visible = false;
                    txtKN_NguoiKy_td.Visible = false;
                    LoadDropNguoiKyTP(dropTLD_NguoiKy, null);
                    LoadDropNguoiKyTP(dropKN_NguoiKy, null);
                    cmdXoa.Visible = false;
                }
                //--------------------------------
                lbtDownload.Visible = (String.IsNullOrEmpty(oT.KQ_TENFILE + "")) ? false : true;
                //--------------------------------
                int is_anqh = (string.IsNullOrEmpty(oT.ISANQUOCHOI + "")) ? 0 : (int)oT.ISANQUOCHOI;
                if (is_anqh > 0)
                    LoadDSTraloidon(oT.ID);
                else
                    pnThongBaoAQH.Visible = false;
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
                lbthongbao.ForeColor = System.Drawing.Color.Red;
            }
        }
        void LoadThongTinVuAn(Decimal VuAnID, GDTTT_VUAN oT)
        {
            if (oT != null)
            {
                // txtGQD_SoCV.Text = oT.GQD_SOCV;
                txtGQD_NgayCV.Text = (String.IsNullOrEmpty(oT.GQD_NGAYPHATHANHCV + "") || (oT.GQD_NGAYPHATHANHCV == DateTime.MinValue)) ? "" : ((DateTime)oT.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);

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
                if (!string.IsNullOrEmpty(oT.GQD_ISHOANTHA + "") && ((int)oT.GQD_ISHOANTHA == 1))
                {
                    LoadDropNguoiKy(dropHTA_NguoiKy, null);
                    pnHoanTHA.Visible = true;
                    rdHoanTHA.SelectedValue = "1";
                    txtHTA_So.Text = oT.GQD_HOANTHA_SO + "";
                    if (oT.GQD_HOANTHA_NGAY != null)
                        txtHTA_Ngay.Text = ((DateTime)oT.GQD_HOANTHA_NGAY).ToString("dd/MM/yyyy", cul);
                    Cls_Comon.SetValueComboBox(dropHTA_NguoiKy, oT.GQD_HOANTHA_NGUOIKYID);
                    cmdXoaHoanTHA.Visible = true;
                }
                else pnHoanTHA.Visible = cmdXoaHoanTHA.Visible = false;

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
                //----------------------------------
                //LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                //LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                txtVuAn_NguyenDon.Text = oT.NGUYENDON;
                txtVuAn_BiDon.Text = oT.BIDON;
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
        private void LoadDSTraloidon(decimal VuAnID)
        {
            int is_visible = 0;
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            // DataTable tbl = oBL.TRALOIDON_DANHSACH(VuAnID);
            GDTTT_DON_TRALOI_BL objBL = new GDTTT_DON_TRALOI_BL();
            DataTable tbl = objBL.GetAllTB_TheoLoai(VuAnID, 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
                is_visible++;
            }
            else rpt.Visible = false;
            if (is_visible > 0)
                pnThongBaoAQH.Visible = true;
            else
                pnThongBaoAQH.Visible = false;
        }
        void LoadDSTraLoiDon_AHS()
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            GDTTT_DON_TRALOI_BL oBl = new GDTTT_DON_TRALOI_BL();
            //Lay ra Khang nghị
            DataTable tblKN = oBl.AHS_DSGiaiQuyetDon(VuAnID, 4);
            if (tblKN != null && tblKN.Rows.Count > 0)
            {
                rptKhangNghi.DataSource = tblKN;
                rptKhangNghi.DataBind();
                rptKhangNghi.Visible = true;
                rptKhangNghi.Visible = true;
            }
            else
                rptKhangNghi.Visible = false;
            //Lay ra tra loi don
            DataTable tbl = oBl.AHS_DSGiaiQuyetDon(VuAnID, 3);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptTraLoiDon.DataSource = tbl;
                rptTraLoiDon.DataBind();
                rptTraLoiDon.Visible = true;
                rptTraLoiDon.Visible = true;
            }
            else
                rptTraLoiDon.Visible = false;

        }
        protected void cmdXoaHoanTHA_Click(object sender, EventArgs e)
        {
            string strvid = Request["vid"] + "";
            decimal VuAnID = Convert.ToDecimal(strvid);
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            oVA.GQD_HOANTHA_SO = "";
            oVA.GQD_HOANTHA_NGAY = (DateTime?)null;
            oVA.GQD_HOANTHA_NGUOIKYID = 0;
            oVA.GQD_HOANTHA_TENNGUOIKY = "";
            oVA.GQD_ISHOANTHA = 0;
            dt.SaveChanges();

            rdHoanTHA.SelectedValue = "0";
            pnHoanTHA.Visible = false;
            cmdXoaHoanTHA.Visible = false; ;

            lttMsgHoanTHA.ForeColor = System.Drawing.Color.Blue;
            lttMsgHoanTHA.Text = "Xóa dữ liệu thành công !";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }

        protected void cmdUpdateHoanTHA_Click(object sender, EventArgs e)
        {
            try
            {
                string strvid = Request["vid"] + "";
                decimal VuAnID = Convert.ToDecimal(strvid);
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                oVA.GQD_HOANTHA_SO = "";
                oVA.GQD_HOANTHA_NGAY = (DateTime?)null;
                oVA.GQD_HOANTHA_NGUOIKYID = 0;
                oVA.GQD_HOANTHA_TENNGUOIKY = "";
                oVA.GQD_ISHOANTHA = 0;
                int ishoantha = Convert.ToInt16(rdHoanTHA.SelectedValue);
                if (ishoantha == 1)
                {
                    oVA.GQD_ISHOANTHA = 1;
                    //Update them thong tin Hoan thi hanh an
                    oVA.GQD_HOANTHA_SO = txtHTA_So.Text.Trim();
                    oVA.GQD_HOANTHA_NGAY = (String.IsNullOrEmpty(txtHTA_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHTA_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GQD_HOANTHA_NGUOIKYID = Convert.ToDecimal(dropHTA_NguoiKy.SelectedValue);
                    oVA.GQD_HOANTHA_TENNGUOIKY = dropHTA_NguoiKy.SelectedItem.Text;
                }

                //-----------------------------------              
                dt.SaveChanges();
                if (ishoantha == 1)
                    cmdXoaHoanTHA.Visible = true;
                else
                    cmdXoaHoanTHA.Visible = false;
                lttMsgHoanTHA.ForeColor = System.Drawing.Color.Blue;
                lttMsgHoanTHA.Text = "Cập nhật thành công !";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lttMsgHoanTHA.ForeColor = System.Drawing.Color.Red;
                lttMsgHoanTHA.Text = "Lỗi:" + ex.Message;
            }
        }
        protected void cmdUpdateThongBaoAnQH_Click(object sender, EventArgs e)
        {
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            Update_ThongBaoTL(oVA);
            lbthongbao.ForeColor = System.Drawing.Color.Blue;
            lbthongbao.Text = "Cập nhật thành công !";
            cmdXoa.Visible = true;
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                List<GDTTT_DON_TRALOI> cKQTLD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID).ToList();
                if (cKQTLD.Count > 0 & (rdbLoai.SelectedValue == "2" || rdbLoai.SelectedValue == "3" || rdbLoai.SelectedValue == "4"))
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Vụ án đã có kết quả là TLD (hoặc Kháng nghị)!')", true);
                }
                else
                {
                    UpdateKQGQ(oVA);
                    if (rdbLoai.SelectedValue == "0" || rdbLoai.SelectedValue == "1")
                    {
                        ClearForm();
                        LoadDSTraLoiDon_AHS();
                    }
                    lbthongbao.ForeColor = System.Drawing.Color.Blue;
                    lbthongbao.Text = "Cập nhật thành công !";
                    cmdXoa.Visible = true;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                }
            }
            catch (Exception ex)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi:" + ex.Message;
            }
        }
        //void UpdateKQGQ(GDTTT_VUAN oVA)
        //{
        //    #region Update thong tin KQGQDon                
        //    // oVA.GQD_SOCV = txtGQD_SoCV.Text;
        //    oVA.GQD_NGAYPHATHANHCV = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

        //    //-----------------------------                
        //    oVA.NGUOIKHANGNGHI = 0;
        //    oVA.THAMQUYENXXGDT = 0;
        //    oVA.GQD_GHICHU = txtGhichu.Text;

        //    //-----------------------------------
        //    string loai = rdbLoai.SelectedValue;
        //    oVA.GQD_LOAIKETQUA = Convert.ToDecimal(loai);
        //    string ngay_temp = "";
        //    decimal cKQ= 0;
        //    switch (loai)
        //    {
        //        case "0":
        //            oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_KETQUA = "";
        //            ngay_temp = txtTLD_Ngay.Text.Trim();
        //            oVA.GDQ_NGAY = (DateTime?)null;

        //            GDTTT_DON_TRALOI oTL = new GDTTT_DON_TRALOI();
        //            Decimal DonID = Convert.ToDecimal(dropDon.SelectedValue);
        //            if (DonID > 0)
        //            {
        //                //tra loi don AHS--> luu vao bang GDTTT_Don_TraLoi (TypeTB=3)
        //                Update_KQTLDon_AHS(DonID);
        //                oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text;
        //            }
        //            else
        //            {
        //                oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text;// + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;                        
        //                //--------------------------
        //                decimal CurrDonID = 0;
        //                //Tao kq giai quyet don cho tat ca nguoi khieu nai (chua co kq giai quyet don) 
        //                foreach (ListItem item in dropDon.Items)
        //                {
        //                    CurrDonID = Convert.ToDecimal(item.Value);
        //                    if (CurrDonID != 0)
        //                    {
        //                        try
        //                        {
        //                            List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.TYPETB == ENUM_LOAITHONGBAO_QH.TRALOIDON_AHS
        //                                                                                     && x.DONID == CurrDonID).ToList();
        //                            if (lst == null || lst.Count == 0)
        //                            {
        //                                Update_KQTLDon_AHS(CurrDonID);
        //                                cKQ += 1;
        //                            }  
        //                        }
        //                        catch (Exception ex) {}
        //                    }
        //                }
        //                // kiem tra nếu đã có kết quả cho người khiếu nại thì không tạo tất cả cho đơn trùng này nữa hoặc sửa kết quả cho tất cả
        //                if (cKQ == 0)
        //                {
        //                    Update_KQTLDon_AHS(0);
        //                }

        //            }
        //            LoadDropDonThuLyMoi(null);
        //            break;
        //        case "1":
        //            //manh bo 10/04/2020
        //            //TYPETB = 3 trả lời đơn; thêm TYPETB = 4 la khang nghị; TYPETB = 5 là xếp đơn;  
        //            //Xoa_ThongBaoTraLoiCV(oVA.ID, (int)ENUM_LOAITHONGBAO_QH.TRALOIDON_AHS);
        //            ngay_temp = txtNgayQD.Text.Trim();
        //            oVA.GDQ_SO = txtSoQD.Text;
        //            oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //            oVA.GDQ_NGUOIKY = txtKN_NguoiKy.Text.Trim();
        //            oVA.NGUOIKHANGNGHI = LoaiNguoiKhangNghiID; //Convert.ToDecimal(ddlNguoiKN.SelectedValue);
        //            oVA.THAMQUYENXXGDT = Convert.ToDecimal(ddlThamquyenXX.SelectedValue);

        //            oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
        //            break;
        //        case "2":
        //            //manh bo 10/04/2020
        //            //Xoa_ThongBaoTraLoiCV(oVA.ID, (int)ENUM_LOAITHONGBAO_QH.TRALOIDON_AHS);
        //            ngay_temp = txtNgayXepDon.Text.Trim();
        //            oVA.GDQ_NGUOIKY = txtNguoiDuyetXepDon.Text.Trim();
        //            oVA.GDQ_SO = txtSoXepDon.Text;
        //            oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayXepDon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //            oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
        //            break;
        //        case "3":
        //            oVA.GDQ_NGUOIKY = txtKN_NguoiKy_xlk.Text.Trim();
        //            oVA.GQD_KETQUA = txtNoiDung_xlk.Text;
        //            break;
        //    }
        //    //-----------------------------
        //    //UpdateFile(oVA);
        //    #endregion

        //    //-----------------------------------
        //    oVA.QUATRINH_GHICHU = txtGhichu.Text;
        //    if (loai != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT.ToString())
        //    {
        //        switch (loai)
        //        {
        //            case "0":
        //                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON;
        //                break;
        //            case "1":
        //                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;
        //                break;
        //            case "2":
        //                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
        //                break;
        //            case "3":
        //                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
        //                break;
        //        }
        //    }
        //    dt.SaveChanges();
        //}
        //void Update_KQTLDon_AHS(Decimal DonID)
        //{
        //    GDTTT_DON_TRALOI oTL = null;
        //    bool IsUpdate = false;

        //    decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
        //    List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == 3
        //                                                                        && x.DONID == DonID).ToList();
        //    if (lst != null && lst.Count > 0)
        //    {
        //        oTL = lst[0];
        //        IsUpdate = true;
        //    }
        //    else oTL = new GDTTT_DON_TRALOI();

        //    oTL.VUANID = VuAnID;
        //    oTL.TYPETB = 3;
        //    oTL.DONID = DonID;
        //    oTL.LOAI = 0; //nguoi khieu nai
        //    oTL.TRANGTHAI = 1;

        //    oTL.SO = txtTLD_So.Text;
        //    oTL.NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //    oTL.NGUOIKY = txtTLD_NguoiKy.Text.Trim();
        //    oTL.NGAYPHATHANH = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //    oTL.GHICHU = txtGhichu.Text.Trim();
        //    try
        //    {
        //        GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
        //        oTL.NGUOINHAN = oDon.NGUOIGUI_HOTEN;
        //        oTL.DIACHINHAN = oDon.NGUOIGUI_DIACHI;
        //    }
        //    catch (Exception ex)
        //    {
        //        if (DonID == 0) 
        //            oTL.NGUOINHAN = "Tất cả";
        //    }
        //    if (!IsUpdate)
        //    {
        //        dt.GDTTT_DON_TRALOI.Add(oTL);
        //    }
        //    dt.SaveChanges();
        //}
        void Update_ThongBaoTL(GDTTT_VUAN oVA)
        {
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            if (rdbLoai.SelectedValue == "0")
            {
                Decimal CurrDSID = 0, ThongBaoID = 0;
                string temp = "";
                int LoaiTLD = 2; //0:Nguoi khiếu nại/1:Đương su/2:Co quan chuyen don/3:Khac

                foreach (RepeaterItem item in rpt.Items)
                {
                    HiddenField hddThongBaoID = (HiddenField)item.FindControl("hddThongBaoID");
                    HiddenField hddDonID = (HiddenField)item.FindControl("hddDonID");

                    Literal lttHoTen = (Literal)item.FindControl("lttHoTen");
                    Literal lttAddress = (Literal)item.FindControl("lttAddress");
                    TextBox txtSo = (TextBox)item.FindControl("txtSo");
                    TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                    TextBox txtGhiChu = (TextBox)item.FindControl("txtGhiChu");

                    ThongBaoID = Convert.ToDecimal(hddThongBaoID.Value);
                    temp = "," + ThongBaoID.ToString() + ",";

                    //----------------------------
                    if ((!String.IsNullOrEmpty(txtSo.Text.Trim())) || (!String.IsNullOrEmpty(txtNgay.Text.Trim())))
                    {
                        #region Insert hoac update
                        bool isupdate = false;
                        GDTTT_DON_TRALOI objEdit = null;
                        try
                        {
                            if (ThongBaoID > 0)
                            {
                                objEdit = dt.GDTTT_DON_TRALOI.Where(x => x.ID == ThongBaoID).Single();
                                if (objEdit != null)
                                    isupdate = true;
                                else objEdit = new GDTTT_DON_TRALOI();
                            }
                            else objEdit = new GDTTT_DON_TRALOI();
                        }
                        catch (Exception ex) { objEdit = new GDTTT_DON_TRALOI(); }

                        objEdit.VUANID = VuAnID;
                        objEdit.DONID = (String.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value);
                        objEdit.DUONGSUID = CurrDSID;
                        objEdit.NGUOINHAN = lttHoTen.Text;
                        objEdit.DIACHINHAN = lttAddress.Text;
                        objEdit.TYPETB = ENUM_LOAITHONGBAO_QH.TBKQTRALOI;
                        objEdit.SO = txtSo.Text.Trim();
                        objEdit.NGAY = (String.IsNullOrEmpty(txtNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        objEdit.LOAI = LoaiTLD;
                        //objEdit.LOAI " 0:Nguoi khiếu nại/1:Đương su/2:Co quan chuyen don/3:Khac

                        objEdit.GHICHU = txtGhiChu.Text;
                        if (!isupdate)
                            dt.GDTTT_DON_TRALOI.Add(objEdit);
                        try
                        {
                            dt.SaveChanges();
                        }
                        catch (EntityDataSourceValidationException e)
                        {
                            lbthongbao.Text = "Lỗi Entities: " + e.Message;
                        }
                        catch (System.Data.Entity.Validation.DbEntityValidationException ex)
                        {
                            string strErr = "";
                            foreach (var eve in ex.EntityValidationErrors)
                            {
                                foreach (var ve in eve.ValidationErrors)
                                {
                                    strErr += ve.PropertyName + " : " + ve.ErrorMessage;
                                }
                            }
                            lbthongbao.Text = "Có lỗi, hãy thử lại: " + strErr;
                        }
                        #endregion
                    }
                    else
                    {
                        #region  Delete
                        if (ThongBaoID > 0)
                        {
                            GDTTT_DON_TRALOI obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == ThongBaoID).Single();
                            if (obj != null)
                            {
                                dt.GDTTT_DON_TRALOI.Remove(obj);
                                dt.SaveChanges();
                            }
                        }
                        #endregion
                    }
                }
            }
            else
            {
                #region xoa thong bao tl kq
                List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == ENUM_LOAITHONGBAO_QH.TBKQTRALOI).ToList();
                if (lst != null && lst.Count > 0)
                {
                    foreach (GDTTT_DON_TRALOI item in lst)
                        dt.GDTTT_DON_TRALOI.Remove(item);
                    dt.SaveChanges();
                }
                #endregion
            }
        }
        protected void cmdXoa_Click(object sender, EventArgs e)
        {
            XoaKQGiaiQuyetDon();
            LoadDropDonThuLyMoi(null);
            ClearForm();
        }
        void XoaKQGiaiQuyetDon()
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            decimal trangthai_id = 0;
            int count_totrinh = 0;
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVA != null)
            {
                trangthai_id = (decimal)oVA.TRANGTHAIID;
                //-------------------
                if (trangthai_id != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT)
                {
                    oVA.GQD_LOAIKETQUA = null;
                    oVA.GQD_KETQUA = "";
                    oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                    oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
                    oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
                    count_totrinh = (string.IsNullOrEmpty(oVA.ISTOTRINH + "")) ? 0 : (int)oVA.ISTOTRINH;
                    if (count_totrinh > 0)
                    {
                        try
                        {
                            List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTRINH).ToList();
                            if (lstTT != null && lstTT.Count > 0)
                            {
                                GDTTT_TOTRINH objToTrinh = lstTT[0];
                                oVA.TRANGTHAIID = objToTrinh.TINHTRANGID;
                            }
                            else
                                SetTrangThai(oVA);
                        }
                        catch (Exception ex)
                        {
                            SetTrangThai(oVA);
                        }
                    }
                    else SetTrangThai(oVA);

                    //------------------------------
                    dt.SaveChanges();
                    Xoa_ThongBaoTraLoiCV(VuAnID, (int)ENUM_LOAITHONGBAO_QH.TBKQTRALOI);
                    Xoa_ThongBaoTraLoiCV(VuAnID, (int)ENUM_LOAITHONGBAO_QH.TRALOIDON_AHS);
                    Xoa_ThongBaoTraLoiCV(VuAnID, 4);
                    //------------------------------
                    ClearForm();
                    lbthongbao.ForeColor = System.Drawing.Color.Blue;
                    lbthongbao.Text = "Xóa kết quả giải quyết đơn thành công!";
                    cmdXoa.Visible = false;
                    //rdbLoai.Enabled = true;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                }
                else
                {
                    lbthongbao.ForeColor = System.Drawing.Color.Blue;
                    lbthongbao.Text = "Vụ án đang ở giai đoạn 'Thụ lý xét xử GDTTT'. Không được phép xóa kết quả giải quyết đơn!";
                }
            }
        }
        void Xoa_ThongBaoTraLoiCV(decimal VuAnID, int typetb)
        {
            try
            {
                List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == typetb).ToList();
                if (lst != null && lst.Count > 0)
                {
                    foreach (GDTTT_DON_TRALOI it in lst)
                        dt.GDTTT_DON_TRALOI.Remove(it);
                    dt.SaveChanges();
                }
                if (typetb == ENUM_LOAITHONGBAO_QH.TBKQTRALOI)
                    LoadDSTraloidon(VuAnID);
                else if (typetb == ENUM_LOAITHONGBAO_QH.TRALOIDON_AHS)
                    LoadDSTraLoiDon_AHS();
                else if (typetb == 4)
                    LoadDSTraLoiDon_AHS();
            }
            catch (Exception ex) { }
        }
        GDTTT_VUAN SetTrangThai(GDTTT_VUAN oVA)
        {
            oVA.ISTOTRINH = 0;
            decimal THAMTRAVIENID = (string.IsNullOrEmpty(oVA.THAMTRAVIENID + "")) ? 0 : (decimal)oVA.THAMTRAVIENID;
            if (THAMTRAVIENID > 0)
                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
            else
                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
            return oVA;
        }
        void ClearForm()
        {
            rdbLoai.SelectedValue = "0";
            pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = false;
            pnTLD.Visible = true;

            rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = true;

            txtTLD_So.Text = txtTLD_Ngay.Text = txtTLD_NguoiKy.Text = "";
            txtSoQD.Text = txtNgayQD.Text = txtKN_NguoiKy.Text = "";
            txtTB_So.Text = txtTB_Ngay.Text = txtTB_NguoiKy.Text = "";

            txtKN_NguoiKy_xlk.Text = txtNoiDung_xlk.Text = "";
            try
            {
                ddlThamquyenXX.SelectedIndex = 0;
            }
            catch (Exception exx) { }
            txtSoXepDon.Text = txtNgayXepDon.Text = txtNguoiDuyetXepDon.Text = "";
            txtTLD_NguoiKy_td.Visible = false;
            txtKN_NguoiKy_td.Visible = false;
            dropTLD_NguoiKy_td.Visible = true;
            dropKN_NguoiKy_td.Visible = true;
            LoadDropNguoiKyTP(dropTLD_NguoiKy, null);
            LoadDropNguoiKyTP(dropKN_NguoiKy, null);
            txtGQD_NgayCV.Text = txtGhichu.Text = "";
        }
        void UpdateFile(GDTTT_VUAN obj)
        {
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";
                    if (chkKySo.Checked)
                    {
                        string[] arr = hddFilePath.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath(temp_folder_upload) + strFilePath;
                    }
                    else
                        strFilePath = hddFilePath.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        obj.KQ_NOIDUNGFILE = buff;
                        obj.KQ_TENFILE = oF.Name;
                        obj.KQ_KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { }
            }
        }

        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            pnDon.Visible = false;
            string loai = rdbLoai.SelectedValue;
            string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            if (loaitoa.Contains("cấp cao"))
                lbl_GQD_NgayCV.Text = "Ngày phát hành của Phòng";
            else
                lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";
            pnXuLyKhac.Visible = false;
            switch (loai)
            {
                case "0":
                    pnQDKN.Visible = pnXepDon.Visible = pnVKS_GQ.Visible = false;
                    pnTLD.Visible = true;
                    pnDon.Visible = true;
                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtTLD_Ngay.Text = string.Empty;
                    //txtTLD_So.Text = string.Empty;

                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "1":
                    LoadDropThamQuyenXX();
                    pnQDKN.Visible = true;
                    //pnDon.Visible = pnTLD.Visible = pnXepDon.Visible = false;
                    //manhnd sua
                    pnDon.Visible = true;
                    pnTLD.Visible = pnXepDon.Visible = pnVKS_GQ.Visible = false;

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtNgayQD.Text = string.Empty;
                    //txtSoQD.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "2":
                    pnXepDon.Visible = true;
                    pnQDKN.Visible = pnDon.Visible = pnTLD.Visible = pnVKS_GQ.Visible = false;

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtNgayXepDon.Text = string.Empty;
                    //txtSoXepDon.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "3":
                    pnXuLyKhac.Visible = true;
                    pnTLD.Visible = pnXepDon.Visible = pnQDKN.Visible = pnVKS_GQ.Visible = false;
                    lbl_GQD_NgayCV.Text = "Ngày xử lý";
                    //-------------
                    pnDon.Visible = false;

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txt_xlk_so.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "4":
                    pnXuLyKhac.Visible = pnTLD.Visible = pnXepDon.Visible = pnQDKN.Visible = false;
                    pnVKS_GQ.Visible = true;
                    if (loaitoa.Contains("cấp cao"))
                        lbl_GQD_NgayCV.Text = "Ngày phát hành của Phòng";
                    else
                        lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";


                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtTB_Ngay.Text = string.Empty;
                    //txtTB_So.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    break;
            }
        }
        void LoadDropDonThuLyMoi(string donid)
        {
            /* CD_TRANGTHAI   when 1 then  'Da chuyen'
                            when 2 then  'Da nhan' 
                            when 3 then  'Bi tra lai' 
                            else 'Chua chuyen'                            
            ISTHULY when 1: 'thu ly moi', 2:'da thu ly'*/
            dropDon.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            List<GDTTT_DON> lst = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                                    && x.CD_TRANGTHAI == 2
                                                    && x.ISTHULY == 1).ToList();
            if (lst != null && lst.Count > 0)
            {
                String temp = "";
                ListItem item = new ListItem();
                foreach (GDTTT_DON obj in lst)
                {
                    temp = (String.IsNullOrEmpty(obj.TL_SO + "")) ? "" : "Số TL " + obj.TL_SO;
                    temp += (String.IsNullOrEmpty(obj.TL_NGAY + "") || (obj.TL_NGAY == DateTime.MinValue)) ? "" : " Ngày TL " + ((DateTime)obj.TL_NGAY).ToString("dd/MM/yyyy", cul);

                    //30/11/2026---------------
                    item = new ListItem();
                    if (obj.CV_TENDONVI != null)
                        obj.NGUOIGUI_HOTEN = obj.CV_TENDONVI;

                    item.Text = obj.NGUOIGUI_HOTEN + (String.IsNullOrEmpty(temp) ? "" : " (" + temp + ")");
                    item.Value = obj.ID.ToString();
                    //- Nếu đơn này chưa có kết quả thì hiển thị ra--
                    List<GDTTT_DON_TRALOI> lstKQTLD = dt.GDTTT_DON_TRALOI.Where(x => x.DONID == obj.ID).ToList();
                    if (lstKQTLD.Count == 0 || donid != null)
                        dropDon.Items.Add(item);
                }
            }
            dropDon.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        //-----------------------------
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile)
                {
                    string strFileName = Cls_Comon.ChuyenTenFileUpload(AsyncFileUpLoad.FileName);
                    string path = Server.MapPath(temp_folder_upload) + strFileName;
                    AsyncFileUpLoad.SaveAs(path);
                    path = path.Replace("\\", "/");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                }
            }
            catch (Exception ex) { }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oND = dt.GDTTT_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.KQ_TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.KQ_NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.KQ_TENFILE + "&Extension=" + oND.KQ_KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void txtHTA_Ngay_TextChanged(object sender, EventArgs e)
        {
            try
            {
                string strvid = Request["vid"] + "";
                decimal VuAnID = Convert.ToDecimal(strvid);
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                if (oVA.LOAIAN != null)
                {
                    decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                    decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal so_ = 0;
                    lbthongbao.Text = "";
                    //string loai = rdbLoai.SelectedValue;
                    so_ = oBL.HoanTHA_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtHTA_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString());
                    txtHTA_So.Text = Convert.ToString(so_);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtTLD_Ngay_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_AHS_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtTLD_So.Text = Convert.ToString(so_);
                    }
                }

            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_AHS_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtSoQD.Text = Convert.ToString(so_);
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtNgayXepDon_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_AHS_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtSoXepDon.Text = Convert.ToString(so_);
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtGQD_NgayCV_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_AHS_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txt_xlk_so.Text = Convert.ToString(so_);
                    }
                }

            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtTB_Ngay_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_AHS_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtTB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtTB_So.Text = Convert.ToString(so_);
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        //protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        //{
        //    SetNgayCV(txtSoQD, txtNgayQD);
        //}
        void SetNgayCV(TextBox control_so, TextBox control_ngay)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime ngay = (DateTime)((String.IsNullOrEmpty(control_ngay.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(control_ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastGQD_SoCV(PhongBanID, ngay);
            control_so.Text = SoCV + "";
        }
        protected void dropTLD_NguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtTLD_NguoiKy.Text = dropTLD_NguoiKy.SelectedItem.Text;
        }
        protected void dropKN_NguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtKN_NguoiKy.Text = dropKN_NguoiKy.SelectedItem.Text;
        }
        protected void rdHoanTHA_SelectedIndexChanged(object sender, EventArgs e)
        {
            int ishoantha = Convert.ToInt16(rdHoanTHA.SelectedValue);
            if (ishoantha == 1)
            {
                LoadDropNguoiKy(dropHTA_NguoiKy, null);
                pnHoanTHA.Visible = true;
            }
            else
                pnHoanTHA.Visible = false;
        }
        protected void rptTraLoiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_TraLoiDon(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }
        void Load_TraLoiDon(Decimal CurrID)
        {
            try
            {
                GDTTT_DON_TRALOI obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == CurrID).Single();
                if (obj != null)
                {
                    txtSoQD.Text = txtTLD_So.Text = obj.SO + "";
                    String ngay_temp = (String.IsNullOrEmpty(obj.NGAY + "")) ? "" : ((DateTime)obj.NGAY).ToString("dd/MM/yyyy", cul);
                    txtNgayQD.Text = txtTLD_Ngay.Text = ngay_temp;

                    ngay_temp = (String.IsNullOrEmpty(obj.NGAYPHATHANH + "")) ? "" : ((DateTime)obj.NGAYPHATHANH).ToString("dd/MM/yyyy", cul);
                    txtGQD_NgayCV.Text = ngay_temp;
                    txtGhichu.Text = obj.GHICHU;
                    txtTLD_NguoiKy.Text = obj.NGUOIKY + "";
                    LoadDropDonThuLyMoi(obj.DONID + "");
                    Cls_Comon.SetValueComboBox(dropDon, obj.DONID);
                    rdbLoai.SelectedValue = "0";

                    pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = false;
                    pnTLD.Visible = true;
                    pnDon.Visible = true;
                }
            }
            catch (Exception ex) { }
        }
        void XoaTraLoiDon(Decimal CurrID)
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            GDTTT_DON_TRALOI obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == CurrID).Single();

            dt.GDTTT_DON_TRALOI.Remove(obj);
            dt.SaveChanges();

            //Kiem tra kết quả này có phải KN không, nếu là KN thì cần kiểm tra để cập nhật lại Trạng thái Vụ án.

            List<GDTTT_DON_TRALOI> Ckn = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 4).ToList();
            // Nếu vẫn còn kết quả KN khác thì không cho xóa
            if (Ckn.Count == 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                oVA.GQD_LOAIKETQUA = null;
                oVA.GQD_KETQUA = "";
                oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
                oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;

                // cập nhật lại trạng thái Vụ an khi còn kết quả trả lời đơn 
                List<GDTTT_DON_TRALOI> CTLD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 3).ToList();
                List<GDTTT_DON_TRALOI> CXD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 5).ToList();
                List<GDTTT_DON_TRALOI> CXLK = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 6).ToList();
                if (CTLD != null && CTLD.Count > 0)
                {
                    oVA.TRANGTHAIID = 13;
                    oVA.GQD_LOAIKETQUA = 0;
                    oVA.GQD_KETQUA = "Trả lời đơn";

                }

                dt.SaveChanges();
            }

            List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID).ToList();
            if (lst != null && lst.Count > 0)
            {
                ClearForm();
                lbthongbao.ForeColor = System.Drawing.Color.Blue;
                lbthongbao.Text = "Xóa trả lời đơn thành công!";
            }
            else
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                Decimal trangthai_id = (decimal)oVA.TRANGTHAIID;
                oVA.GQD_LOAIKETQUA = null;
                oVA.GQD_KETQUA = "";
                oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
                oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
                //-------------------
                if (trangthai_id != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT)
                {
                    Decimal count_totrinh = (string.IsNullOrEmpty(oVA.ISTOTRINH + "")) ? 0 : (int)oVA.ISTOTRINH;
                    if (count_totrinh > 0)
                    {
                        try
                        {
                            List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTRINH).ToList();
                            if (lstTT != null && lstTT.Count > 0)
                            {
                                GDTTT_TOTRINH objToTrinh = lstTT[0];
                                oVA.TRANGTHAIID = objToTrinh.TINHTRANGID;
                            }
                            else
                                SetTrangThai(oVA);
                        }
                        catch (Exception ex)
                        {
                            SetTrangThai(oVA);
                        }
                    }
                    else SetTrangThai(oVA);
                }

                //------------------------------
                dt.SaveChanges();
                Xoa_ThongBaoTraLoiCV(VuAnID, (int)ENUM_LOAITHONGBAO_QH.TBKQTRALOI);
                //------------------------------
                ClearForm();
                lbthongbao.ForeColor = System.Drawing.Color.Blue;
                lbthongbao.Text = "Xóa kết quả giải quyết đơn thành công!";
                cmdXoa.Visible = false;
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }

            LoadDSTraLoiDon_AHS();
        }

        //-------------------------
        void UpdateKQGQ(GDTTT_VUAN oVA)
        {
            #region Update thong tin KQGQDon                
            // oVA.GQD_SOCV = txtGQD_SoCV.Text;


            //-----------------------------  
            //-----------------------------------
            string ngay_temp = "";
            decimal cKQ = 0;
            string loai = rdbLoai.SelectedValue;
            if (loai == "1")
            {//Neu la khang nghi thi cap nhat don vi khang nghi va Tham quyen xet xu vu an
                oVA.NGUOIKHANGNGHI = CurrDonViID;//don vi nao nhap ho so thi CA don vi do Khang Nghi
                oVA.THAMQUYENXXGDT = Convert.ToDecimal(ddlThamquyenXX.SelectedValue);
            }
            else
            {
                oVA.NGUOIKHANGNGHI = 0;
                oVA.THAMQUYENXXGDT = 0;
            }

            oVA.GQD_GHICHU = txtGhichu.Text;


            List<GDTTT_DON_TRALOI> cKQKN = dt.GDTTT_DON_TRALOI.Where(x => x.TYPETB == 4 && x.VUANID == oVA.ID).ToList();
            //Nếu có kết quả kháng nghị thì không update lại Loại kết quả
            if (cKQKN.Count == 0)
            {
                oVA.GQD_NGAYPHATHANHCV = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oVA.GQD_LOAIKETQUA = Convert.ToDecimal(loai);
                if (loai == "0")
                {
                    oVA.GDQ_SO = txtTLD_So.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text;
                    rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                }
                else if (loai == "1")
                {

                    ngay_temp = txtNgayQD.Text.Trim();
                    oVA.GDQ_SO = txtSoQD.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GDQ_NGUOIKY = txtKN_NguoiKy.Text.Trim();
                    oVA.NGUOIKHANGNGHI = LoaiNguoiKhangNghiID; //Convert.ToDecimal(ddlNguoiKN.SelectedValue);
                    oVA.THAMQUYENXXGDT = Convert.ToDecimal(ddlThamquyenXX.SelectedValue);
                    oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                }
                else if (loai == "2")
                {

                    ngay_temp = txtNgayXepDon.Text.Trim();
                    oVA.GDQ_NGUOIKY = txtNguoiDuyetXepDon.Text.Trim();
                    oVA.GDQ_SO = txtSoXepDon.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayXepDon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                }
                else if (loai == "3")
                {
                    oVA.GDQ_NGUOIKY = txtKN_NguoiKy_xlk.Text.Trim();
                    oVA.GQD_KETQUA = txtNoiDung_xlk.Text;
                    oVA.GDQ_SO = txt_xlk_so.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[4].Enabled = false;
                }
                else if (loai == "4")
                {
                    oVA.GDQ_SO = txtTB_So.Text;
                    ngay_temp = txtTB_Ngay.Text.Trim();
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTB_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GDQ_NGUOIKY = txtTB_NguoiKy.Text.Trim();
                    oVA.GQD_KETQUA = "số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
                }

            }

            GDTTT_DON_TRALOI oTL = new GDTTT_DON_TRALOI();
            Decimal DonID = Convert.ToDecimal(dropDon.SelectedValue);
            //Tra loi doi thi moi update cả 2
            if (loai == "0" || loai == "1")
            {
                if (DonID > 0)
                {
                    //tra loi don AHS--> luu vao bang GDTTT_Don_TraLoi (TypeTB=3)
                    Update_KQTLDon_AHS(DonID);
                }
                else
                {
                    decimal CurrDonID = 0;
                    //Tao kq giai quyet don cho tat ca nguoi khieu nai (chua co kq giai quyet don) 
                    foreach (ListItem item in dropDon.Items)
                    {
                        CurrDonID = Convert.ToDecimal(item.Value);
                        if (CurrDonID != 0)
                        {
                            try
                            {
                                List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.TYPETB == ENUM_LOAITHONGBAO_QH.TRALOIDON_AHS
                                                                                         && x.DONID == CurrDonID).ToList();
                                if (lst == null || lst.Count == 0)
                                {
                                    Update_KQTLDon_AHS(CurrDonID);
                                    cKQ += 1;
                                }
                            }
                            catch (Exception ex) { }
                        }
                    }
                    // kiem tra nếu đã có kết quả cho người khiếu nại thì không tạo tất cả cho đơn trùng này nữa hoặc sửa kết quả cho tất cả
                    //if (cKQ == 0)
                    //{
                    //    Update_KQTLDon_AHS(0);
                    //}

                }
            }
            LoadDropDonThuLyMoi(null);


            #endregion

            //-----------------------------------
            oVA.QUATRINH_GHICHU = txtGhichu.Text;
            if (loai != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT.ToString())
            {
                switch (loai)
                {
                    case "0":
                        oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON;
                        break;
                    case "1":
                        oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;
                        break;
                    case "2":
                        oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
                        break;
                    case "3":
                        oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                        break;
                    case "4":
                        oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                        break;
                }
            }
            dt.SaveChanges();
        }

        void Update_KQTLDon_AHS(Decimal DonID)
        {
            GDTTT_DON_TRALOI oTL = null;
            bool IsUpdate = false;
            decimal loai = Convert.ToDecimal(rdbLoai.SelectedValue);
            decimal v_TYPETB = 3;
            if (loai == 1)
                v_TYPETB = 4;
            else
                v_TYPETB = 3;
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == v_TYPETB
                                                                                && x.DONID == DonID).ToList();
            if (lst != null && lst.Count > 0)
            {
                oTL = lst[0];
                IsUpdate = true;
            }
            else oTL = new GDTTT_DON_TRALOI();

            oTL.VUANID = VuAnID;
            oTL.TYPETB = v_TYPETB;
            oTL.DONID = DonID;
            oTL.LOAI = 0; //nguoi khieu nai
            oTL.TRANGTHAI = 1;

            if (loai == 1)
            {
                oTL.SO = txtSoQD.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.NGUOIKY = ddlThamquyenXX.SelectedItem + "";
            }
            else
            {
                oTL.SO = txtTLD_So.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.NGUOIKY = txtTLD_NguoiKy.Text.Trim();
            }


            oTL.NGAYPHATHANH = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oTL.GHICHU = txtGhichu.Text.Trim();
            try
            {
                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
                oTL.NGUOINHAN = oDon.NGUOIGUI_HOTEN;
                oTL.DIACHINHAN = oDon.NGUOIGUI_DIACHI;
            }
            catch (Exception ex)
            {
                if (DonID == 0)
                    oTL.NGUOINHAN = "Tất cả";
            }
            if (!IsUpdate)
            {
                dt.GDTTT_DON_TRALOI.Add(oTL);
            }
            dt.SaveChanges();
        }

        protected void rptKhangNghi_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_KQKN(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }


        void Load_KQKN(Decimal CurrID)
        {
            try
            {
                GDTTT_DON_TRALOI obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == CurrID && x.TYPETB == 4).Single();
                if (obj != null)
                {
                    txtSoQD.Text = txtTLD_So.Text = obj.SO + "";
                    String ngay_temp = (String.IsNullOrEmpty(obj.NGAY + "")) ? "" : ((DateTime)obj.NGAY).ToString("dd/MM/yyyy", cul);
                    txtNgayQD.Text = txtTLD_Ngay.Text = ngay_temp;

                    ngay_temp = (String.IsNullOrEmpty(obj.NGAYPHATHANH + "")) ? "" : ((DateTime)obj.NGAYPHATHANH).ToString("dd/MM/yyyy", cul);
                    txtGQD_NgayCV.Text = ngay_temp;
                    txtGhichu.Text = obj.GHICHU;

                    LoadDropDonThuLyMoi(obj.DONID + "");
                    Cls_Comon.SetValueComboBox(dropDon, obj.DONID);
                    rdbLoai.SelectedValue = "1";

                    LoadDropThamQuyenXX();

                    if (obj.NGUOIKY == "Tòa án nhân dân tối cao")
                        Cls_Comon.SetValueComboBox(ddlThamquyenXX, 1);
                    else if (obj.NGUOIKY == "Tòa án nhân dân cấp cao tại Hà Nội")
                        Cls_Comon.SetValueComboBox(ddlThamquyenXX, 4);
                    else if (obj.NGUOIKY == "Tòa án nhân dân cấp cao tại Đà Nẵng")
                        Cls_Comon.SetValueComboBox(ddlThamquyenXX, 5);
                    else if (obj.NGUOIKY == "Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh")
                        Cls_Comon.SetValueComboBox(ddlThamquyenXX, 6);

                    pnQDKN.Visible = true;
                    //pnDon.Visible = true;
                    pnTLD.Visible = pnXepDon.Visible = false;
                }
            }
            catch (Exception ex) { }
        }
    }
}
