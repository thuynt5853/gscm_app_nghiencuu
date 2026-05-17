using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.Danhmuc;
using BL.GSTP.DLQGC12;
using BL.GSTP.QLAN;
using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.PhucTham.BanAn
{
    public partial class BanAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DKKContextContainer dkk = new DKKContextContainer();
        Decimal ToaAnID = 0, CurrUserID = 0;
        private const decimal BANAN = 1, QUYETDINH = 2;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                if (CurrUserID > 0)
                {
                    ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                    if (!IsPostBack)
                    {
                        hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                        hddVuAnID.Value = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? "" : Session[ENUM_LOAIAN.AN_HINHSU] + "";
                        decimal VUANID = Convert.ToDecimal(hddVuAnID.Value);
                        if (!String.IsNullOrEmpty(txtNgayBanAn.Text))
                            SetNewSoBA();
                        LoadDrop_Anle();
                        LoadCombobox();
                        LoadListToiDanh_ByVuAnId();
                        LoadNguoiKyInfo();
                        LoaThongTinBanAn();
                        LoadDsBiCao();
                        CheckQuyen();
                        LoadQD();
                        LoadGrid();
                        CheckCongbo(VUANID);
                        Load_txbSoBiCao_PhapNhan();
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            } catch (Exception ex)
            {
                lbThongBaoQD.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }
        private void LoadDrop_Anle()
        {
            //GTEL-DUCPH 23-09-2025 thêm try catch để xử lý pass qua khi không gọi được DB LINK môi trường test
            try
            {
                CONGBO_BL TK_BL = new CONGBO_BL();
                DataTable tbl = TK_BL.DBLINK_GET_LIST_ANLE();
                ddlCBBA_Anle.DataSource = tbl;
                ddlCBBA_Anle.DataTextField = "SO_ANLE";
                ddlCBBA_Anle.DataValueField = "SO_ANLE";
                ddlCBBA_Anle.DataBind();
                ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
            }
            catch (Exception e)
            {
                // GTEL-DUCPH  NC: 23-09-2025 Fake rỗng
                DataTable tbl = new DataTable();
                tbl.Columns.Add("TEN", typeof(string));
                tbl.Columns.Add("SO_ANLE", typeof(string));
                ddlCBBA_Anle.DataSource = tbl;
                ddlCBBA_Anle.DataTextField = "SO_ANLE";
                ddlCBBA_Anle.DataValueField = "SO_ANLE";
                ddlCBBA_Anle.DataBind();
                ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
            }
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU} AND CAPXETXU = 3 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdateBanAnST, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdSave2, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdSaveThongKe, oPer.CAPNHAT);
            decimal VUANID = Convert.ToDecimal(hddVuAnID.Value);
            bool IsUpdateThuLyPT = true;
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lttMsgBanAn.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";

                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdSave2, false);
                Cls_Comon.SetButton(cmdSaveThongKe, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            if (oT != null)
            {
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    IsUpdateThuLyPT = false;
                }
            }

            List<AHS_PHUCTHAM_THULY> lstCount = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VUANID).ToList();
            if (lstCount.Count == 0)
            {
                IsUpdateThuLyPT = false;
            }

            #region  Nếu có quyết định thì ẩn bản án - HIEUVM
            List<AHS_PHUCTHAM_QUYETDINH_VUAN> lstQD = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID && (x.LOAIQDID == 10 || x.LOAIQDID == 3 || x.LOAIQDID == 15 || x.QUYETDINHID == 324)).ToList();
            if (lstQD.Count >= 1)
            {
                pnQDVV.Visible = true;
                pnBAPT.Visible = false;
                rdbPanelQD.Enabled = false;
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                Cls_Comon.SetButton(btnUpdate, false);
            }
            else
            {
                rdbPanelQD.Enabled = true;
            }

            List<AHS_PHUCTHAM_BANAN> lstBA = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VUANID).ToList();
            if (lstBA.Count >= 1)
            {
                pnBAPT.Visible = true;
                rdbPanelBA.Enabled = false;
                rdbPanelQD.Enabled = false;
                rdbPanelBA.SelectedValue = BANAN.ToString();
            }
            else
            {
                rdbPanelBA.Enabled = true;
            }
            #endregion

            if (!IsUpdateThuLyPT)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdSave2, false);
                Cls_Comon.SetButton(cmdSaveThongKe, false);

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }

            //Kiểm tra đã phân công thẩm phán giải quyết
            List<AHS_THAMPHANGIAIQUYET> lstTPGQ = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VUANID && x.MAVAITRO == "VTTP_GIAIQUYETPHUCTHAM").ToList<AHS_THAMPHANGIAIQUYET>();
            if (lstTPGQ.Count == 0)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdSave2, false);
                Cls_Comon.SetButton(cmdSaveThongKe, false);

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }

            if (!Check_Phancongthamphan())
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdSave2, false);
                Cls_Comon.SetButton(cmdSaveThongKe, false);

                Cls_Comon.SetButton(btnUpdate, false);
            }

            /*Nếu có tống đạt thì ko được xóa bản án sơ thẩm*/
            AHS_TONGDAT td = dt.AHS_TONGDAT.Where(x => x.VUANID == VUANID && ( x.BIEUMAUID == 291)).FirstOrDefault(); /// vnpt -- xoá check biểu mẫu sơ thẩm đã tống đạt trên phúc thẩm
            if (td != null)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ án đã tống đạt không được xóa";
                Cls_Comon.SetButton(cmdHuyBanAn, false);

                Cls_Comon.SetButton(btnUpdate, false);
            }

            /*Nếu chưa nhập quyết định đưa vụ án ra xét xử thì không cho nhập bản án*/
            AHS_PHUCTHAM_QUYETDINH_VUAN oQD = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID && x.LOAIQDID == 5
                                                                            && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/
                                                                            ).FirstOrDefault();
            if (oQD == null)
            {
                lttMsgBanAn.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdSave2, false);
                Cls_Comon.SetButton(cmdSaveThongKe, false);
            }
            
            if (rdbPanelQD.SelectedValue == "2" && ddlQuyetdinh.SelectedValue != "0")
            {
                Cls_Comon.SetButton(btnUpdate, true);
            }
        }
        void SetNewSoBA()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //Số Bản án mới
            DateTime ngayBA;
            if (!String.IsNullOrEmpty(txtNgayBanAn.Text))
                ngayBA = DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayBA = DateTime.Now;

            String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "AHS_PT", ngayBA).ToString();
            txtSoBanAn.Text = STTNew;
        }
        protected void txtNgayBanAn_TextChanged(object sender, EventArgs e)
        {
            SetNewSoBA();
        }
        
        Boolean Check_Phancongthamphan()
        {
            try
            {
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                List<AHS_PHUCTHAM_HDXX> lst = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID
                                                                           && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList<AHS_PHUCTHAM_HDXX>();

                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch { return false; }
        }
        private void LoadNguoiKyInfo()
        {
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            AHS_PHUCTHAM_HDXX oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID
                                                                 && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.ID).FirstOrDefault<AHS_PHUCTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo != null && dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKy.Text = txtNguoiKyQDVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = (dtCanBo.Rows[0]["ChucVu"].ToString() != "") ? dtCanBo.Rows[0]["ChucVu"].ToString() : dtCanBo.Rows[0]["ChucDanh"].ToString();
                    hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                txtNguoiKy.Text = "";
            }
        }
        private void LoaThongTinBanAn()
        {
            hddToaAnID.Value = ToaAnID.ToString();
            DM_TOAAN objTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID && x.HIEULUC == 1).SingleOrDefault<DM_TOAAN>();
            if (objTA != null)
            {
                txtToaAn.Text = objTA.TEN;
                txtDiaDiem.Text = objTA.DIACHI;
                txtNgayBanAn.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            }
            //-------------------------------------------
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            AHS_PHUCTHAM_BANAN obj = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault();
            if (obj != null)
            {
                //pnZonekythuong.Visible = true;
                hddID.Value = obj.ID.ToString();
                LoadDsBiCao();
                //----------------------------------------------------------
                txtSBC_GIUNGUYEN_AN_ST.Text = obj.SBC_GIUNGUYEN_AN_ST + "";
                txtSBC_SUA_AN_ST.Text = obj.SBC_SUA_AN_ST + "";
                txtSBC_CHAPNHAN_TOANBO.Text = obj.SBC_CHAPNHAN_TOANBO + "";
                txtSBC_CHAPNHAN_MOTPHAN.Text = obj.SBC_CHAPNHAN_MOTPHAN + "";

                ddlKetQuaPhucTham.SelectedValue = obj.KETQUAPHUCTHAMID.ToString();
                LoadDropLyDoBanAn();
                ddlLyDoBanAn.SelectedValue = obj.LYDOBANANID.ToString();
                
                if ((obj.ISANLE == null || obj.ISANLE == 1) && obj.SOANLE == null)
                {
                    ddlCBBA_Anle.Items.Insert(ddlCBBA_Anle.Items.Count, new ListItem("Hãy chọn số án lệ", "-1"));
                    ddlCBBA_Anle.SelectedValue = "-1";
                }
                else
                {
                    ddlCBBA_Anle.SelectedValue = string.IsNullOrEmpty(obj.SOANLE + "") ? "0" : obj.SOANLE;
                }

                rdAnRutGon.SelectedValue = obj.ISANRUTGON + "";
                rdBaoLucGD.SelectedValue = obj.ISBAOLUCGIADINH + "";
                rdXetXuLuuDong.SelectedValue = obj.ISXXLUUDONG + "";
                rdCongboBA.SelectedValue = obj.ISCONGBOBA + "";
                //-----------------------------
                txtNgayBanAn.Text = obj.NGAYBANAN + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)obj.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                //((DateTime)obj.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                txtSoBanAn.Text = obj.SOBANAN + "";

                //-----------------------------
                ddlToiDanhVuAn.SelectedValue = string.IsNullOrEmpty(obj.TOIDANHCHINH_VUAN + "") ? "0" : obj.TOIDANHCHINH_VUAN.ToString();

                txtNgayMoPhienToa.Text = obj.NGAYMOPHIENTOA + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)obj.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                txtDiaDiem.Text = obj.DIADIEM + "";
                //----------------------------
                rdSuaHinhPhatBS.SelectedValue = obj.TK_SUAHPBOSUNG + "";
                rdSuaBoiThuongTH.SelectedValue = obj.TK_BOITHUONGTH + "";
                rdSuaKhac.SelectedValue = obj.TK_SUAKHAC + "";
                rdSuaQDAnSoTham.SelectedValue = obj.TK_SUAQD_ANST + "";
                rdKhoiToTaiToa.SelectedValue = obj.TK_KHOITOTAITOA + "";
                rdKoRutKhangCao.SelectedValue = obj.TK_NONERUTKHANGCAO + "";
                rdDuyetKhangNghiVKS.SelectedValue = obj.TK_DUYETKHANGNGHI_VKS + "";
                rdViPhamHan.SelectedValue = obj.TK_VIPHAMHAN + "";
                if (obj.TK_DUYETKHANGNGHI_VKS > 0)
                {
                    //txtDuyetKN_VKS_BiCao.Enabled = true;
                    txtDuyetKN_VKS_BiCao.Text = obj.TK_DUYETKHANGNGHI_VKS_SBC + "";
                    txtDuyetKN_VKS_PhapNhan.Text = obj.TK_DUYETKHANGNGHI_VKS_SPN + "";
                }
                if (obj.TK_SUAHPBOSUNG > 0)
                {
                    txtSuaHinhPhatBS_BiCao.Text = obj.TK_SUAHPBOSUNG_SBC + "";
                    txtSuaHinhPhatBS_PhapNhan.Text = obj.TK_SUAHPBOSUNG_SPN + "";
                }
                if (obj.TK_BOITHUONGTH > 0)
                {
                    txtSuaBoiThuongTH_BiCao.Text = obj.TK_BOITHUONGTH_SBC + "";
                    txtSuaBoiThuongTH_PhapNhan.Text = obj.TK_BOITHUONGTH_SPN + "";
                }
                if (obj.TK_SUAKHAC > 0)
                {
                    txtSuaKhac_BiCao.Text = obj.TK_SUAKHAC_SBC + "";
                    txtSuaKhac_PhapNhan.Text = obj.TK_SUAKHAC_SPN + "";
                }
                if (obj.TK_SUAQD_ANST > 0)
                {
                    txtSuaQDAnSoTham_BiCao.Text = obj.TK_SUAQD_ANST_SBC + "";
                    txtSuaQDAnSoTham_PhapNhan.Text = obj.TK_SUAQD_ANST_SPN + "";
                }
                if (obj.TK_VIPHAMHAN > 0)
                {
                    txtViPhamHan_BiCao.Text = obj.TK_VIPHAMHAN_SBC + "";
                    txtViPhamHan_PhapNhan.Text = obj.TK_VIPHAMHAN_SPN + "";
                }
                //--------------------------------
                if ((obj.TENFILE + "") != "")
                {
                    lbtDownload.Visible = true;
                    lbtXoaFile.Visible = true;
                }
                else
                {
                    lbtDownload.Visible = false;
                    lbtXoaFile.Visible = false;
                }
            }
            else
            {
                //pnZonekythuong.Visible = false;
                pnAnPhi.Enabled = false;
                txtNgayMoPhienToa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                // SetNewSoBanAn();
            }
        }

        //-----------------lUU THONG TIN AN SOTHAM--------------------------------
        protected void cmdUpdateBanAnST_Click(object sender, EventArgs e)
        {
            string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
            decimal VUANID = Convert.ToDecimal(current_id);
            if (!CheckCongbo(VUANID))
                return;

            string so =  txtSoBanAn.Text;
            DateTime ngayBA = DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "AHS_PT", so, ngayBA);
            if (CheckID > 0)
            {
                Decimal CurrBanAnId = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                String strMsg = "";
                String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "AHS_PT", ngayBA).ToString();
                if (CheckID != CurrBanAnId)
                {
                    strMsg = "Số bản án " + txtSoBanAn.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                    txtSoBanAn.Text = STTNew;
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtSoBanAn.Focus();
                    return;
                }
            }
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            AHS_PHUCTHAM_BANAN oND1 = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_PHUCTHAM_BANAN>();
            if (oND1 != null)
            {
                // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == oND1.VUANID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_PHUCTHAM_BANAN).FirstOrDefault();
                if (oTD != null)
                {
                    lttMsgBanAn.Text = "Bạn không thể sửa khi đã tống đạt!";
                    return;
                }
            }
            UpdateBanAn();
            hddPageIndex.Value = "1";
            LoadDsBiCao();

            Capnhat_AHS_TONGHOPHINHPHAT();

            lttMsgBanAn.Text = "Cập nhật thông tin bản án thành công!.";
            lttMsgAnPhi.Text = lttMsgThongKe.Text = "";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        void UpdateBanAn()
        {
            Boolean IsUpdate = false;
            DateTime date_temp;
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            AHS_PHUCTHAM_BANAN obj = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_PHUCTHAM_BANAN>();
            if (obj != null)
                IsUpdate = true;
            else
            {
                obj = new AHS_PHUCTHAM_BANAN();
            }
            obj.VUANID = VuAnID;
            obj.KETQUAPHUCTHAMID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
            obj.LYDOBANANID = Convert.ToDecimal(ddlLyDoBanAn.SelectedValue);
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";
                        string[] arr = hddFilePath.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        obj.NOIDUNGFILE = buff;
                        obj.TENFILE = oF.Name;
                        obj.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                    lbtDownload.Visible = true;
                    lbtXoaFile.Visible = true;
                    MSG_file.Text = string.Empty;
                }
                catch { }/* lbthongbao.Text = ex.Message; }*/
            }

            //-----------------------------------------   
            date_temp = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYBANAN = date_temp;
            obj.TOIDANHCHINH_VUAN = ddlToiDanhVuAn.SelectedValue == "0" ? (decimal?)null : Convert.ToDecimal(ddlToiDanhVuAn.SelectedValue);


            //-----------------------------------------           
            date_temp = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYMOPHIENTOA = date_temp;
            obj.DIADIEM = txtDiaDiem.Text.Trim();

            //-----------------------------------------
            obj.TOAANID = ToaAnID;

            obj.ISCONGBOBA = rdCongboBA.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongboBA.SelectedValue);

            obj.NGUOIKY = (String.IsNullOrEmpty(hddNguoiKyID.Value)) ? 0 : Convert.ToDecimal(hddNguoiKyID.Value);
            obj.SOBANAN = txtSoBanAn.Text.Trim();
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_PHUCTHAM_BANAN.Add(obj);
                dt.SaveChanges();
                InsertToiDanhTuCaoTrangSangBanAnPT(obj.ID);
                hddID.Value = obj.ID + "";
            }

            /* 25.04.2025 Gọi hàm UploadFileID, lưu vào bảng AHN_FILE là có Bản án
             * File bản án nếu đính kèm sẽ lưu vào bảng AHN_SOTHAM_BANAN_FILE
             * (Bản án chỉ có 1 nên không cần tạo trường FILEID như Quyết định
             * 2022 Đã bỏ hoàn toàn và k tống đạt Bản án
             * Trước đó bắt buộc có file đính kèm mới được Tống đạt */
            AHS_VUAN_BL oBL = new AHS_VUAN_BL();
            decimal rFileID = 0;
            if (IsUpdate)
            {
                rFileID = UploadFileID(VuAnID, obj?.FILEID ?? 0, "28-HS");
            } else
            {
                rFileID = UploadFileID(VuAnID, 0, "28-HS");
            }
            if (rFileID > 0)
            {
                obj.FILEID = rFileID;
                dt.SaveChanges();
            }

            AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (obj.NGAYBANAN != null)
            {
                bool isnew = false;
                var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                        $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
                                                                        $"  AND CAPXETXU = {3} ");

                BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                if (temp_congbo == null)
                {
                    isnew = true;
                    temp_congbo = new BAQD_CONGBO();
                }

                temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                temp_congbo.CAPXETXU = 3;
                temp_congbo.ISBA = 1;
                temp_congbo.BAQDID = obj.ID;
                temp_congbo.NGAYHIEULUC = obj.NGAYBANAN;
                temp_congbo.MAVUAN = oDon.MAVUAN;
                temp_congbo.VUVIECID = obj.VUANID.Value;

                if (isnew)
                {
                    temp_congbo.NGAYTAO = DateTime.Now;
                    temp_congbo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Insert(temp_congbo);
                }
                else if (temp_congbo != null && temp_congbo.TRANGTHAI != 2 && temp_congbo.TRANGTHAI != 3)
                {
                    temp_congbo.NGAYSUA = DateTime.Now;
                    temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Update(temp_congbo);
                }
            }

            lttMsgBanAn.Text = "Lưu dữ liệu bản án thành công!";
            
        }
        void InsertToiDanhTuCaoTrangSangBanAnPT(decimal BanAnID)
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            Decimal BiCaoID = 0;
            Boolean isupdate = false;
            AHS_PHUCTHAM_BANAN_BICAO objBC = new AHS_PHUCTHAM_BANAN_BICAO();
            List<AHS_PHUCTHAM_BICANBICAO> lst = dt.AHS_PHUCTHAM_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_PHUCTHAM_BICANBICAO>();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_PHUCTHAM_BICANBICAO item in lst)
                {
                    BiCaoID = (Decimal)item.BICANID;
                    #region Update_BiCan_phuc tham
                    isupdate = false;
                    objBC = dt.AHS_PHUCTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID
                                                                && x.BICAOID == BiCaoID).SingleOrDefault<AHS_PHUCTHAM_BANAN_BICAO>();
                    if (objBC != null)
                        isupdate = true;
                    else
                        objBC = new AHS_PHUCTHAM_BANAN_BICAO();

                    objBC.BANANID = BanAnID;
                    objBC.BICAOID = BiCaoID;

                    if (!isupdate)
                    {
                        if (objBC.TOA_GIAIQUYET_ID == null)
                        {
                            objBC.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        dt.AHS_PHUCTHAM_BANAN_BICAO.Add(objBC);
                        dt.SaveChanges();
                    }
                    #endregion               
                    ThemHinhPhat(BiCaoID, BanAnID);
                }
            }
        }
        protected void rdCongboBA_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        void ThemHinhPhat(Decimal BiCaoID, decimal BanAnID)
        {
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            bool checkQD = true;

            List<AHS_PHUCTHAM_QUYETDINH_BICAN> QDBC = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == BiCaoID).ToList();
            foreach (AHS_PHUCTHAM_QUYETDINH_BICAN qddcbc in QDBC)
            {
                DM_QD_QUYETDINH DMQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == qddcbc.QUYETDINHID).FirstOrDefault();
                if (DMQD.TEN.Contains("Quyết định đình chỉ") == true)
                {
                    checkQD = false;
                }
            }
            try
            {
                AHS_SOTHAM_KHANGCAO bckc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.NGUOIKCID == BiCaoID).FirstOrDefault();
                AHS_SOTHAM_RUTKHANGCAO bcrkc = dt.AHS_SOTHAM_RUTKHANGCAO.Where(x => x.KHANGCAOID == bckc.ID).FirstOrDefault();

                if (bcrkc != null)
                {
                    checkQD = false;
                }

            }
            catch { }

            if (checkQD == true)
            {
                Decimal BanAnST_ID = 0;
                //------------------------------
                AHS_SOTHAM_BANAN st = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (st != null) BanAnST_ID = st.ID;
                //------------------------------
                Boolean IsUpdate = false;
                AHS_PHUCTHAM_BANAN_DIEU_CT Ba_PT_CT = new AHS_PHUCTHAM_BANAN_DIEU_CT();
                List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnST_ID
                                                                                                && x.BICANID == BiCaoID
                                                                                                ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET Ba_ST_CT in lst)
                {
                    IsUpdate = false;
                    Ba_PT_CT = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x =>
                                                                    x.BANANID == BanAnID
                                                                  && x.BICANID == Ba_ST_CT.BICANID
                                                                  && x.DIEULUATID == Ba_ST_CT.DIEULUATID
                                                                  && x.TOIDANHID == Ba_ST_CT.TOIDANHID
                                                                  && x.HINHPHATID == Ba_ST_CT.HINHPHATID
                                                             ).SingleOrDefault<AHS_PHUCTHAM_BANAN_DIEU_CT>();
                    // Kiểm tra đã có điều đó ở PT_CT chưa
                    if (Ba_PT_CT == null)
                        Ba_PT_CT = new AHS_PHUCTHAM_BANAN_DIEU_CT();
                    else
                        IsUpdate = true;

                    Ba_PT_CT.BANANID = BanAnID;
                    Ba_PT_CT.BICANID = BiCaoID;
                    Ba_PT_CT.DIEULUATID = Ba_ST_CT.DIEULUATID;
                    Ba_PT_CT.TOIDANHID = Ba_ST_CT.TOIDANHID;

                    //Nếu KQXXPT là "Giữ nguyên bản án, quyết định sơ thẩm" thì copy các hình phạt từ sơ thẩm lên phúc thẩm
                    AHS_PHUCTHAM_BANAN ocheck_KQXXPTbj = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_PHUCTHAM_BANAN>();
                    if (ocheck_KQXXPTbj.KETQUAPHUCTHAMID == 1)
                    {
                        Ba_PT_CT.HINHPHATID = Ba_ST_CT.HINHPHATID;
                        Ba_PT_CT.LOAIHINHPHAT = Ba_ST_CT.LOAIHINHPHAT;
                        Ba_PT_CT.ISANTREO = Ba_ST_CT.ISANTREO;
                        Ba_PT_CT.ISCHANGE = Ba_ST_CT.ISCHANGE;
                        Ba_PT_CT.TF_VALUE = Ba_ST_CT.TF_VALUE;
                        Ba_PT_CT.SH_VALUE = Ba_ST_CT.SH_VALUE;
                        Ba_PT_CT.TG_NAM = Ba_ST_CT.TG_NAM;
                        Ba_PT_CT.TG_THANG = Ba_ST_CT.TG_THANG;
                        Ba_PT_CT.TG_NGAY = Ba_ST_CT.TG_NGAY;
                        Ba_PT_CT.K_VALUE1 = Ba_ST_CT.K_VALUE1;
                        Ba_PT_CT.K_VALUE2 = Ba_ST_CT.K_VALUE2;
                        Ba_PT_CT.TGTT_NAM = Ba_ST_CT.TGTT_NAM;
                        Ba_PT_CT.TGTT_THANG = Ba_ST_CT.TGTT_THANG;
                        Ba_PT_CT.TGTT_NGAY = Ba_ST_CT.TGTT_NGAY;
                    }
                    else
                    {
                        Ba_PT_CT.HINHPHATID = 0;
                        Ba_PT_CT.LOAIHINHPHAT = 0;
                        Ba_PT_CT.ISCHANGE = 0;
                    }
                    // Kiểm tra tên tội danh là null hay ko
                    if (String.IsNullOrEmpty(Ba_ST_CT.TENTOIDANH))
                    {
                        if (Ba_ST_CT.TOIDANHID > 0)
                            Ba_PT_CT.TENTOIDANH = "";
                    }
                    else
                        Ba_PT_CT.TENTOIDANH = Ba_ST_CT.TENTOIDANH;
                    Ba_PT_CT.ISMAIN = (string.IsNullOrEmpty(Ba_ST_CT.ISMAIN + "")) ? 0 : Ba_ST_CT.ISMAIN;

                    if (!IsUpdate)
                        dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Add(Ba_PT_CT);
                    dt.SaveChanges();
                }
            }
        }

        #region Load DS bi cao
        public void LoadDsBiCao()
        {
            int vu_an_id = Convert.ToInt32(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            AHS_PHUCTHAM_BANAN_BL objBL = new AHS_PHUCTHAM_BANAN_BL();
            DataTable tbl = objBL.GetDsBiCaoByVuAn(vu_an_id);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();

                if (Convert.ToInt16(tbl.Rows[0]["IsShow"] + "") > 0)
                    cmdSave2.Enabled = pnAnPhi.Enabled = true;
                else
                {
                    lttMsgAnPhi.Text = "Chưa có bản án xét xử phúc thẩm!";
                    cmdSave2.Enabled = pnAnPhi.Enabled = false;
                }
            }
            else
            {
                //  pnAnPhi.Enabled = false;
                lttMsgAnPhi.Text = "Chưa có bị cáo được xét xử phúc thẩm. Đề nghị kiểm tra lại!";
                cmdSave2.Enabled = pnAnPhi.Enabled = false;
            }
            // Total bi cao la ca nhan / phap nhan
            //Số bị cáo là cá nhân
            DataRow[] arr = tbl.Select("LOAIDOITUONG = 0");
            if (arr != null && arr.Length != 0)
                hddTotalCaNhan.Value = arr.Length + "";
            else
                hddTotalCaNhan.Value = "0";
            //Số bị cáo là pháp nhân
            arr = tbl.Select("LOAIDOITUONG IN (1,2)");
            if (arr != null && arr.Length != 0)
                hddTotalPhapNhan.Value = arr.Length + "";
            else
                hddTotalPhapNhan.Value = "0";
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;

                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);

                decimal BiCaoId = Convert.ToDecimal(dv["BiCanID"] + "");
                TextBox txtAnPhi = (TextBox)e.Item.FindControl("txtAnPhi");
                CheckBox cb = (CheckBox)e.Item.FindControl("chkThamGiaPhienToa");
                txtAnPhi.Text = String.IsNullOrEmpty(dv["AnPhi"] + "") ? "" : (Convert.ToDouble(dv["AnPhi"])).ToString("#,#", cul) + "";

                TextBox txtNgaynhanbanan = (TextBox)e.Item.FindControl("txtNgaynhanbanan");
                DateTime ngaynhan = String.IsNullOrEmpty(dv["NgayNhanBanAn"] + "") ? DateTime.MinValue : Convert.ToDateTime(dv["NgayNhanBanAn"] + "");
                if (ngaynhan == DateTime.MinValue)
                    txtNgaynhanbanan.Text = "";
                else
                    txtNgaynhanbanan.Text = ngaynhan.ToString("dd/MM/yyyy", cul);

                int IsShow = Convert.ToInt16(dv["IsShow"] + "");

                AHS_TONGHOPHINHPHAT tonghophinhphat = DataExtensions.GetAllWithClause<AHS_TONGHOPHINHPHAT>($"VUANID= {VuAnID} AND BICAOID = {BiCaoId}").FirstOrDefault();
                try
                { 
                    Label lblTHtoidanh = (Label)e.Item.FindControl("lblTHtoidanh");
                    lblTHtoidanh.Text = tonghophinhphat.Tonghophinhphat_ST(VuAnID, BiCaoId);
                }
                catch (Exception ex) { }
                
                try
                {
                    Label lblTHtoidanhPT = (Label)e.Item.FindControl("lblTHtoidanhPT");
                    if (tonghophinhphat.TONGHOPHINHPHAT != null)
                    {
                        lblTHtoidanhPT.Text = tonghophinhphat.Tonghophinhphat_Sosanh(VuAnID, BiCaoId);
                    }
                    else
                    {
                        lblTHtoidanhPT.Text = tonghophinhphat.Tonghophinhphat_PT(VuAnID, BiCaoId);
                    }
                }

                catch (Exception ex) { }

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!String.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID)
                {
                    cb.Visible = false;
                    txtAnPhi.Visible = false;
                    txtNgaynhanbanan.Visible = false;
                }

                //GTEL-DUCPH 29-09-2025 check bị can Đã Đồng Bộ và gán vào hiddenField
                KHOBAQD_BL ahsNCBl = new KHOBAQD_BL();
                string daDongBo = ahsNCBl.IsExistKHOBADQ(0, VuAnID,3,ENUM_LOAIVUVIEC_TEXT.AN_HINHSU) ? "1" : "0";
                HiddenField hddDaDongBo = (HiddenField)e.Item.FindControl("hddDaDongBo");
                hddDaDongBo.Value = daDongBo;
            }
        }
        #endregion

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoad.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoad.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                    }
                }
            }
            catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                AHS_PHUCTHAM_BANAN oND = dt.AHS_PHUCTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }
        protected void lbtXoaFile_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                AHS_PHUCTHAM_BANAN oND = dt.AHS_PHUCTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    oND.NOIDUNGFILE = null;
                    oND.TENFILE = null;
                    oND.KIEUFILE = null;
                    dt.SaveChanges();
                    MSG_file.Text = "File bản án đã được xóa thành công";
                    lbtDownload.Visible = false;
                    lbtXoaFile.Visible = false;
                }
            }
            catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }

        //------------LUU THONG TIN CHI TIEU HO TRO THONG KE---------------------    
        protected void cmdSaveThongKe_Click(object sender, EventArgs e)
        {
            Update_ChiTieuTK();
            lttMsgAnPhi.Text = lttMsgBanAn.Text = "";
        }
        void Update_ChiTieuTK()
        {
            if (ddlCBBA_Anle.SelectedValue == "-1")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Chưa chọn số án lệ áp dụng. Hãy kiểm tra lại. " + "')", true);
                lttMsgBanAn.Text = "Lỗi: Dữ liệu thống kê lưu không thành công!";
                return;
            }

            Boolean IsUpdate = false;
            Decimal VuAnId = Convert.ToDecimal(hddVuAnID.Value);
            AHS_PHUCTHAM_BANAN obj = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnId).SingleOrDefault<AHS_PHUCTHAM_BANAN>();
            if (obj != null)
                IsUpdate = true;
            else
                obj = new AHS_PHUCTHAM_BANAN();

            obj.VUANID = VuAnId;
            obj.ISANLE = ddlCBBA_Anle.SelectedValue == "0" ? 0 : 1;
            obj.SOANLE = ddlCBBA_Anle.SelectedValue;
            obj.ISANRUTGON = Convert.ToDecimal(rdAnRutGon.SelectedValue);
            obj.ISBAOLUCGIADINH = Convert.ToDecimal(rdBaoLucGD.SelectedValue);
            obj.ISXXLUUDONG = Convert.ToDecimal(rdXetXuLuuDong.SelectedValue);

            obj.SBC_GIUNGUYEN_AN_ST = (string.IsNullOrEmpty(txtSBC_GIUNGUYEN_AN_ST.Text.Trim())) ? 0 : Convert.ToDecimal(txtSBC_GIUNGUYEN_AN_ST.Text.Trim());
            obj.SBC_SUA_AN_ST = (string.IsNullOrEmpty(txtSBC_SUA_AN_ST.Text.Trim())) ? 0 : Convert.ToDecimal(txtSBC_SUA_AN_ST.Text.Trim());
            obj.SBC_CHAPNHAN_TOANBO = (string.IsNullOrEmpty(txtSBC_CHAPNHAN_TOANBO.Text.Trim())) ? 0 : Convert.ToDecimal(txtSBC_CHAPNHAN_TOANBO.Text.Trim());
            obj.SBC_CHAPNHAN_MOTPHAN = (string.IsNullOrEmpty(txtSBC_CHAPNHAN_MOTPHAN.Text.Trim())) ? 0 : Convert.ToDecimal(txtSBC_CHAPNHAN_MOTPHAN.Text.Trim());

            obj.TK_SUAHPBOSUNG = Convert.ToDecimal(rdSuaHinhPhatBS.SelectedValue);

            //Thêm số bị cáo/ pháp nhân khi chọn Sửa phần hình phạt bổ sung hoặc áp dụng các biện pháp tư pháp là Có
            if (obj.TK_SUAHPBOSUNG > 0)
            {
                obj.TK_SUAHPBOSUNG_SBC = Convert.ToDecimal(txtSuaHinhPhatBS_BiCao.Text.Trim());
                obj.TK_SUAHPBOSUNG_SPN = Convert.ToDecimal(string.IsNullOrEmpty(txtSuaHinhPhatBS_PhapNhan.Text.Trim()) ? "0" : txtSuaHinhPhatBS_PhapNhan.Text);
            }
            obj.TK_BOITHUONGTH = Convert.ToDecimal(rdSuaBoiThuongTH.SelectedValue);

            //Thêm số bị cáo/ pháp nhân khi chọn Sửa phần bồi thường thiệt hại và quyết định xử lý vật chứng là Có
            if (obj.TK_BOITHUONGTH > 0)
            {
                obj.TK_BOITHUONGTH_SBC = Convert.ToDecimal(txtSuaBoiThuongTH_BiCao.Text.Trim());
                obj.TK_BOITHUONGTH_SPN = Convert.ToDecimal(string.IsNullOrEmpty(txtSuaBoiThuongTH_PhapNhan.Text.Trim()) ? "0" : txtSuaBoiThuongTH_PhapNhan.Text);
            }
            obj.TK_SUAKHAC = Convert.ToDecimal(rdSuaKhac.SelectedValue);

            //Thêm số bị cáo/ pháp nhân khi chọn Sửa các phần khác là Có
            if (obj.TK_SUAKHAC > 0)
            {
                obj.TK_SUAKHAC_SBC = Convert.ToDecimal(txtSuaKhac_BiCao.Text.Trim());
                obj.TK_SUAKHAC_SPN = Convert.ToDecimal(string.IsNullOrEmpty(txtSuaKhac_PhapNhan.Text.Trim()) ? "0" : txtSuaKhac_PhapNhan.Text);
            }

            obj.TK_SUAQD_ANST = Convert.ToDecimal(rdSuaQDAnSoTham.SelectedValue);

            //Thêm số bị cáo/ pháp nhân khi chọn Sửa quyết định của bản án sơ thẩm đối với bị cáo không có kháng cáo, kháng nghị là Có
            if (obj.TK_SUAQD_ANST > 0)
            {
                obj.TK_SUAQD_ANST_SBC = Convert.ToDecimal(txtSuaQDAnSoTham_BiCao.Text.Trim());
                obj.TK_SUAQD_ANST_SPN = Convert.ToDecimal(string.IsNullOrEmpty(txtSuaQDAnSoTham_PhapNhan.Text.Trim()) ? "0" : txtSuaQDAnSoTham_PhapNhan.Text);
            }

            //Thêm phần Vi phạm hạn tạm giam trong giai đoạn xét xử
            obj.TK_VIPHAMHAN = Convert.ToDecimal(rdViPhamHan.SelectedValue);
            if (obj.TK_VIPHAMHAN > 0)
            {
                obj.TK_VIPHAMHAN_SBC = Convert.ToDecimal(txtViPhamHan_BiCao.Text.Trim());
                obj.TK_VIPHAMHAN_SPN = Convert.ToDecimal(string.IsNullOrEmpty(txtViPhamHan_PhapNhan.Text.Trim()) ? "0" : txtViPhamHan_PhapNhan.Text);
            }

            obj.TK_KHOITOTAITOA = Convert.ToDecimal(rdKhoiToTaiToa.SelectedValue);
            obj.TK_NONERUTKHANGCAO = Convert.ToDecimal(rdKoRutKhangCao.SelectedValue);
            obj.TK_DUYETKHANGNGHI_VKS = Convert.ToDecimal(rdDuyetKhangNghiVKS.SelectedValue);
            if (obj.TK_DUYETKHANGNGHI_VKS > 0)
            {
                obj.TK_DUYETKHANGNGHI_SOBICAO = Convert.ToDecimal(txtDuyetKN_VKS_BiCao.Text);
                obj.TK_DUYETKHANGNGHI_VKS_SPN = Convert.ToDecimal(string.IsNullOrEmpty(txtDuyetKN_VKS_PhapNhan.Text.Trim()) ? "0" : txtDuyetKN_VKS_PhapNhan.Text);
                obj.TK_DUYETKHANGNGHI_VKS_SBC = Convert.ToDecimal(txtDuyetKN_VKS_BiCao.Text);
            }

            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            obj.TOAANID = ToaAnID;

            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                AHS_PHUCTHAM_BANAN_BL objBL = new AHS_PHUCTHAM_BANAN_BL();
                decimal thutu = objBL.GetNewTT(ToaAnID, VuAnId);
                obj.SOBANAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + thutu.ToString();
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_PHUCTHAM_BANAN.Add(obj);
                dt.SaveChanges();
                hddID.Value = obj.ID + "";
            }
            
            lttMsgThongKe.Text = "Lưu dữ liệu thống kê thành công!";
        }

        //----------Update an phi--------------------------------------
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            AHS_PHUCTHAM_BANAN_BICAO obj = null;
            Boolean IsNew = false;
            Decimal BanAnID = Convert.ToDecimal(hddID.Value);

            foreach (RepeaterItem item in rpt.Items)
            {
                IsNew = false;
                HiddenField hddBiCao = (HiddenField)item.FindControl("hddBiCao");
                CheckBox chkThamGiaPhienToa = (CheckBox)item.FindControl("chkThamGiaPhienToa");
                TextBox txtAnPhi = (TextBox)item.FindControl("txtAnPhi");
                TextBox txtNgaynhanbanan = (TextBox)item.FindControl("txtNgaynhanbanan");
                decimal BiCaoId = Convert.ToDecimal(hddBiCao.Value);

                obj = dt.AHS_PHUCTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID && x.BICAOID == BiCaoId).SingleOrDefault<AHS_PHUCTHAM_BANAN_BICAO>();
                if (obj == null)
                {
                    IsNew = true;
                    obj = new AHS_PHUCTHAM_BANAN_BICAO();
                }

                obj.BANANID = BanAnID;
                obj.ISTHAMGIAPHIENTOA = (chkThamGiaPhienToa.Checked) ? 1 : 0;

                DateTime date_temp = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYNHANBANAN = date_temp;
                obj.BICAOID = Convert.ToDecimal(hddBiCao.Value);
                obj.ANPHI = (string.IsNullOrEmpty(txtAnPhi.Text + "")) ? 0 : Convert.ToDecimal(txtAnPhi.Text.Replace(".", ""));
                if (IsNew)
                {
                    if (obj.TOA_GIAIQUYET_ID == null)
                    {
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_PHUCTHAM_BANAN_BICAO.Add(obj);
                }
                dt.SaveChanges();

            }
            lttMsgThongKe.Text = "Lưu dữ liệu thành công!";
            lttMsgBanAn.Text = lttMsgThongKe.Text = "";
            lttMsgAnPhi.Text = "Lưu dữ liệu thành công!";
        }

        void LoadCombobox()
        {
            LoadDropKetQuaPhucTham();
            LoadDropLyDoBanAn();
        }
        private void LoadDropKetQuaPhucTham()
        {
            ddlKetQuaPhucTham.Items.Clear();
            ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISAHS == 1 && x.ISBANAN == 1).OrderBy(y => y.THUTU).ToList();
            ddlKetQuaPhucTham.DataTextField = "TEN";
            ddlKetQuaPhucTham.DataValueField = "ID";
            ddlKetQuaPhucTham.DataBind();
            ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropLyDoBanAn()
        {
            ddlLyDoBanAn.Items.Clear();
            decimal KetQuaID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
            DM_KETQUA_PHUCTHAM_LYDO_BL kqptLyDoBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable dtTable = kqptLyDoBL.DM_KETQUA_PT_LYDO_GETLIST(KetQuaID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                ddlLyDoBanAn.DataSource = dtTable;
                ddlLyDoBanAn.DataTextField = "TEN";
                ddlLyDoBanAn.DataValueField = "ID";
                ddlLyDoBanAn.DataBind();
            }
            ddlLyDoBanAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        protected void ddlKetQuaPhucTham_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadDropLyDoBanAn(); } catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }
        protected void cmdHuyBanAn_Click(object sender, EventArgs e)
        {
            decimal BanAnID = Convert.ToDecimal(hddID.Value);
            // Xóa thông tin bản án
            AHS_PHUCTHAM_BANAN banan = dt.AHS_PHUCTHAM_BANAN.Where(x => x.ID == BanAnID).FirstOrDefault();
            if (banan != null)
            {
                banan.NOIDUNGFILE = null;
                // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == banan.VUANID && x.MAPID == banan.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_PHUCTHAM_BANAN).FirstOrDefault();
                if (oTD != null)
                {
                    lttMsgBanAn.Text = "Bạn không thể xóa khi đã tống đạt!";
                    return;
                }
                //Luu thong tin Bản án Phúc thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                banan.NOIDUNGFILE = null;
                var json = new JavaScriptSerializer().Serialize(banan);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(banan.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Bản án Phúc thẩm án Hình sự", "Xóa", json) == false)
                {
                    return;
                }//Ket thuc
                 //Xoa Bản án Phúc thẩm
                dt.AHS_PHUCTHAM_BANAN.Remove(banan);
            }
            //Xóa thông tin file đính kèm
            List<AHS_PHUCTHAM_BANAN_FILE> files = dt.AHS_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == BanAnID).ToList();
            if (files.Count > 0)
            {
                dt.AHS_PHUCTHAM_BANAN_FILE.RemoveRange(files);
            }
            // Xóa thông tin bị can tham gia phiên tòa
            List<AHS_PHUCTHAM_BANAN_BICAO> tBABCs = dt.AHS_PHUCTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID).ToList();
            if (tBABCs.Count > 0)
            {
                dt.AHS_PHUCTHAM_BANAN_BICAO.RemoveRange(tBABCs);
            }
            // Xóa thông tin hình phạt
            List<AHS_PHUCTHAM_BANAN_DIEU_CT> tGTTs = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BANANID == BanAnID).ToList();
            if (tGTTs.Count > 0)
            {
                dt.AHS_PHUCTHAM_BANAN_DIEU_CT.RemoveRange(tGTTs);
            }

            /* 25.04.2025 Bổ sung Xóa AHN_FILE khi xóa Bản án
             * AHN_FILE phục vụ mục đích lưu trữ các file theo giai đoạn vụ việc/vụ án
             */
            // Xóa file tống đạt bản án
            decimal BieuMauID = 0;
            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == "28-HS").FirstOrDefault();
            if (bm != null)
            {
                BieuMauID = bm.ID;
            }

            AHS_FILE file = dt.AHS_FILE.Where(x => x.VUANID == banan.VUANID && x.BIEUMAUID == BieuMauID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).FirstOrDefault(); 
            if (file != null)
            {
                dt.AHS_FILE.Remove(file);
            }

            decimal vuanid = Convert.ToDecimal(hddVuAnID.Value);
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {vuanid} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
                                                                    $"  AND CAPXETXU = {3} ");

            BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
            if (temp_congbo != null)
            {
                temp_congbo.BAQDID = 0;
                temp_congbo.NGAYHIEULUC = null;
                temp_congbo.NGAYSUA = DateTime.Now;
                temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(temp_congbo);
            }

            dt.SaveChanges();
            ResetControl();
            lttMsgBanAn.Text = "Xóa bản án thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        private void ResetControl()
        {
            txtNgayMoPhienToa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgayBanAn.Text = "";
            ddlKetQuaPhucTham.SelectedIndex = 0;
            ddlLyDoBanAn.SelectedIndex = 0;
            LoadDsBiCao();
            ddlCBBA_Anle.SelectedValue = "0";
            rdAnRutGon.ClearSelection();
            rdBaoLucGD.ClearSelection();
            rdXetXuLuuDong.ClearSelection();
            rdSuaHinhPhatBS.ClearSelection();
            rdSuaBoiThuongTH.ClearSelection();
            rdSuaKhac.ClearSelection();
            rdSuaQDAnSoTham.ClearSelection();
            rdKhoiToTaiToa.ClearSelection();
            rdKoRutKhangCao.ClearSelection();
            rdDuyetKhangNghiVKS.ClearSelection();
            rdViPhamHan.ClearSelection();
            txtDuyetKN_VKS_BiCao.Text = "";
            txtViPhamHan_BiCao.Text = "";
            txtSuaQDAnSoTham_BiCao.Text = "";
            txtSuaKhac_BiCao.Text = "";
            txtSuaBoiThuongTH_BiCao.Text = "";
            txtSuaHinhPhatBS_BiCao.Text = "";
            txtSBC_GIUNGUYEN_AN_ST.Text = "";
            txtSBC_SUA_AN_ST.Text = "";
            txtSBC_CHAPNHAN_TOANBO.Text = "";
            txtSBC_CHAPNHAN_MOTPHAN.Text = "";
            lttMsgBanAn.Text = "";
            lttMsgAnPhi.Text = "";
            lttMsgThongKe.Text = "";
            hddID.Value = "0";
            //Thông tin quyết định
            txtLydo.Text = null;
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            ddlQuyetdinh.SelectedIndex = 0;
            ddlLydo.SelectedIndex = 0;
            pnLyDo.Visible = false;
            pntxtLydo.Visible = false;
            txtSoQD.Text = txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
            hddFilePathQD.Value = "";

            if (pnKetquaPhuctham.Visible == true)
            {
                ddlKetquaQuyetdinh.SelectedIndex = 0;
                if (pnLyDoKetquaPhuctham.Visible == true)
                {
                    ddlLydoQuyetdinh.SelectedIndex = 0;
                }
            }
        }
        
        protected void txtNgaymophientoa_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgayMoPhienToa.Text))
            {
                if (String.IsNullOrEmpty(txtNgayBanAn.Text))
                {
                    txtNgayBanAn.Text = txtNgayMoPhienToa.Text;
                    SetNewSoBA();
                }
            }
        }
        public void cmdReloadParent_Click(object sender, EventArgs e)
        {
            LoadDsBiCao();
        }
        #region HIEUVM Thông tin quyết định
        private void LoadQD()
        {
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN_KETTHUC
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;
            LoadLydo();
            LoadHTXX();
        }
        private void LoadHTXX()
        {
            //HienthiCBBkhichonquyetdinh(20-HS).
            if (ddlQuyetdinh.SelectedItem.Text.Contains("20-HS"))
            {
                ddlHTXX.SelectedIndex = 0;
                pnHinhThucXetXu.Visible = true;
                pnHinhThucXetXu.Enabled = true;
            }
            else
            {
                //ddlHTXX.SelectedItem.Value = null;
                ddlHTXX.SelectedIndex = 0;
                pnHinhThucXetXu.Visible = false;
                pnHinhThucXetXu.Enabled = false;
            }
        }
        private void LoadLydo()
        {
            ddlLydo.Items.Clear();
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();

            if (ddlQuyetdinh.Text == "201" || ddlQuyetdinh.Text == "202")
            {
                pnLyDo.Visible = false;
                pntxtLydo.Visible = true;
                lbtxtLydo.InnerText = "Lý do";
            }
            else if (lst != null && lst.Count > 0)
            {
                pnLyDo.Visible = true;
                pntxtLydo.Visible = false;
            }
            else
            {
                pnLyDo.Visible = false;
                pntxtLydo.Visible = false;
            }

            ddlLydo.Items.Clear();
            foreach (DM_QD_QUYETDINH_LYDO item in lst)
            {
                ddlLydo.Items.Insert(0, new ListItem(item.TEN, item.ID.ToString()));
            }

            //ddlLydo.DataSource = lst;
            //ddlLydo.DataTextField = "TEN";
            //ddlLydo.DataValueField = "ID";
            //ddlLydo.DataBind();
            ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlLydo.SelectedIndex = 0;

        }
        
        private void LoadNguoiKyDdlInfo()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            DataTable tbl = null;
            decimal CanBoID = 0;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
         
            //Lấy danh sách Chánh án, phó chánh án
            tbl = cb_BL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            //Lấy chủ tọa vụ án
            AHS_PHUCTHAM_HDXX oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_PHUCTHAM_HDXX>();
            if (oND != null)
            {
                CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    DataRow dr = tbl.NewRow();
                    dr["MA_TEN"] = dtCanBo.Rows[0]["HOTEN"].ToString() + "-Thẩm phán chủ tọa";
                    dr["ID"] = dtCanBo.Rows[0]["ID"].ToString();
                    tbl.Rows.Add(dr);
                }
            }
            else
            {
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        DataRow dr = tbl.NewRow();
                        dr["MA_TEN"] = dtCanBo.Rows[0]["HOTEN"].ToString() + "-Thẩm phán chủ tọa";
                        dr["ID"] = dtCanBo.Rows[0]["ID"].ToString();
                        tbl.Rows.Add(dr);
                    }
                }
            }
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
            if (CanBoID > 0)
                ddlNguoiky.SelectedValue = CanBoID.ToString();
            hddNguoiKyQDID.Value = ddlNguoiky.SelectedValue;

        }
        protected void rdbPanelBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbPanelBA.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAPT.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAPT.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
        }
        protected void rdbPanelQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbPanelQD.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAPT.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAPT.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
        }
        private void LoadNguoiKyTxtInfo()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            AHS_PHUCTHAM_HDXX oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_PHUCTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKy.Text = txtNguoiKyQDVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = "Thẩm phán chủ tọa";
                    hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKy.Text = txtNguoiKyQDVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = "Thẩm phán giải quyết";
                        hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKy.Text = txtChucvu.Text = "";
            }
        }
        private bool CheckValid()
        {
            if (rdCongBoQD.SelectedValue == "")
            {
                lbThongBaoQD.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
                rdCongBoQD.Focus();
                return false;
            }
            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbThongBaoQD.Text = "Bạn chưa chọn quyết định!";
                ddlQuyetdinh.Focus();
                return false;
            }
            
            int lengthSQD = txtSoQD.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbThongBaoQD.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            if (lengthSQD > 20)
            {
                lbThongBaoQD.Text = "Số quyết định không quá 20 ký tự. Hãy nhập lại!";
                txtSoQD.Focus();
                return false;
            }

            if (String.IsNullOrEmpty(txtNgayQD.Text))
            {
                lbThongBaoQD.Text = "Bạn chưa nhập ngày quyết định !";
                txtNgayQD.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbThongBaoQD.Text = "Bạn chưa nhập ngày quyết định theo định dạng (dd/MM/yyyy) !";
                    txtNgayQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbThongBaoQD.Text = "Ngày quyết định phải nhỏ hơn ngày hiện tại !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("đình chỉ"))
            {
                if (pnLyDo.Visible)
                {
                    if (ddlLydo.SelectedValue == "0")
                    {
                        lbThongBaoQD.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                }
                else if (txtLydo.Visible)
                {
                    if (String.IsNullOrEmpty(txtLydo.Text))
                    {
                        lbThongBaoQD.Text = "Bạn chưa nhập Lý do !";
                        return false;
                    }
                }
            }

            if (!String.IsNullOrEmpty(txtSoQD.Text) && !String.IsNullOrEmpty(txtNgayQD.Text))
            {
                string so = txtSoQD.Text;

                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "AHS", so, ngay, LoaiQD);

                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS", ngay, LoaiQD).ToString();
                    Decimal CurrID = (string.IsNullOrEmpty(hddidQD.Value)) ? 0 : Convert.ToDecimal(hddidQD.Value);
                    if (CheckID != CurrID)
                    {
                        strMsg = "Số Quyết định " + txtSoQD.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoQD.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoQD.Focus();
                        return false;
                    }
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text == "46-HS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với Quyết định tạm đình chỉ (đình chỉ) vụ án")
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0")
                {
                    lbThongBaoQD.Text = "Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!";
                    ddlKetquaQuyetdinh.Focus();
                    return false;
                }
                if (ddlLydoQuyetdinh.SelectedValue == "0" && ddlKetquaQuyetdinh.SelectedValue != "101")
                {
                    lbThongBaoQD.Text = "Bạn chưa chọn lý do. Hãy chọn lại!";
                    ddlLydoQuyetdinh.Focus();
                    return false;
                }
            }
            //if (rdDuyetKhangNghiVKS.SelectedValue == "1" && !String.IsNullOrEmpty(txtDuyetKN_VKS_BiCao.Text))
            //{
            //    lbThongBaoQD.Text = "Bạn chưa nhập Số bị cáo/ pháp nhân";
            //    txtDuyetKN_VKS_BiCao.Focus();
            //    return false;
            //}

            //if (rdSuaHinhPhatBS.SelectedValue == "1" && !String.IsNullOrEmpty(txtSuaHinhPhatBS_BiCao.Text))
            //{
            //    lbThongBaoQD.Text = "Bạn chưa nhập Số bị cáo/ pháp nhân";
            //    txtSuaHinhPhatBS_BiCao.Focus();
            //    return false;
            //}

            //if (rdSuaBoiThuongTH.SelectedValue == "1" && !String.IsNullOrEmpty(txtSuaBoiThuongTH_BiCao.Text))
            //{
            //    lbThongBaoQD.Text = "Bạn chưa nhập Số bị cáo/ pháp nhân";
            //    txtSuaBoiThuongTH_BiCao.Focus();
            //    return false;
            //}

            //if (rdSuaKhac.SelectedValue == "1" && !String.IsNullOrEmpty(txtSuaKhac_BiCao.Text))
            //{
            //    lbThongBaoQD.Text = "Bạn chưa nhập Số bị cáo/ pháp nhân";
            //    txtSuaKhac_BiCao.Focus();
            //    return false;
            //}
            //if (rdSuaQDAnSoTham.SelectedValue == "1" && !String.IsNullOrEmpty(txtSuaQDAnSoTham_BiCao.Text))
            //{
            //    lbThongBaoQD.Text = "Bạn chưa nhập Số bị cáo/ pháp nhân";
            //    txtSuaQDAnSoTham_BiCao.Focus();
            //    return false;
            //}
            //if (rdViPhamHan.SelectedValue == "1" && !String.IsNullOrEmpty(txtViPhamHan_BiCao.Text))
            //{
            //    lbThongBaoQD.Text = "Bạn chưa nhập Số bị cáo/ pháp nhân";
            //    txtViPhamHan_BiCao.Focus();
            //    return false;
            //}
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                decimal VUANID = Convert.ToDecimal(current_id);
                if (!CheckValid() || !CheckCongbo(VUANID))
                    return;

                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_PHUCTHAM_QUYETDINH_VUAN oND;
                if (hddidQD.Value == "" || hddidQD.Value == "0")
                    oND = new AHS_PHUCTHAM_QUYETDINH_VUAN();
                else
                {
                    decimal ID = Convert.ToDecimal(hddidQD.Value);
                    oND = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbThongBaoQD.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                }
                oND.VUANID = VuAnID;
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                //--------------------------------
                try
                {
                    oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                    DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).SingleOrDefault();
                    if (objQD != null)
                        oND.LOAIQDID = objQD.LOAIID;
                }
                catch (Exception exx) { }
                try
                {
                    if (hddFilePathQD.Value != "")
                    {
                        string strFilePath = hddFilePathQD.Value.Replace("/", "\\");
                        #region Lưu file
                        byte[] buff = null;

                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }
                        #endregion
                        File.Delete(strFilePath);
                    }
                }
                catch { }

                if (ddlQuyetdinh.SelectedValue == "201")
                {
                    oND.QUYETDINHID = 201;
                    oND.LYDO_NAME = txtLydo.Text;
                }
                else if (ddlQuyetdinh.SelectedValue == "202")
                {
                    oND.QUYETDINHID = 202;
                    oND.LYDO_NAME = txtLydo.Text;
                }
                else if (pnLyDo.Visible)
                {
                    oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
                }

                oND.LOAIDONVI = 0;
                oND.DONVIID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.SOQUYETDINH = txtSoQD.Text;
                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);

                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                
                oND.LYDOKETQUAID = pnLyDoKetquaPhuctham.Visible == true ? Convert.ToDecimal(ddlLydoQuyetdinh.SelectedValue) : 0;
                oND.KETQUAID = pnKetquaPhuctham.Visible == true ? Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue) : 0;

                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                if (oQDT != null)
                {
                    oND.FILEID = UploadFileID(VuAnID, (hddidQD.Value == "" || hddidQD.Value == "0") ? 0 : oND?.FILEID ?? 0, oQDT.MA);
                }
                //check chuc vu theo loai QĐ:
                if (oND.QUYETDINHID == 201 || oND.QUYETDINHID == 202 || oND.QUYETDINHID == 77 || oND.QUYETDINHID == 78 || oND.QUYETDINHID == 161 || oND.QUYETDINHID == 162 || oND.QUYETDINHID == 163 || oND.QUYETDINHID == 127 || oND.QUYETDINHID == 203)
                {
                    oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                    oND.CHUCVU = ddlNguoiky.SelectedValue;
                }
                else
                {
                    oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyTxtID.Value);
                    oND.CHUCVU = txtChucvu.Text;
                }


                if (hddidQD.Value == "" || hddidQD.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }

                if (oND.LOAIQDID == 3)
                {
                    // update giai đoạn vụ án = sotham
                    AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (objAn != null)
                    {
                        objAn.NGAYSUA = DateTime.Now;
                        objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                }

                dt.SaveChanges();

                if (oQDT.ISCONGBO == 1 && oND.NGAYQD != null)
                {
                    AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();

                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
                                                                            $"  AND CAPXETXU = {3} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                    temp_congbo.CAPXETXU = 3;
                    temp_congbo.ISBA = 0;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYQD;
                    temp_congbo.MAVUAN = oDon.MAVUAN;
                    temp_congbo.VUVIECID = oND.VUANID.Value;

                    if (isnew)
                    {
                        temp_congbo.NGAYTAO = DateTime.Now;
                        temp_congbo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Insert(temp_congbo);
                    }
                    else if (temp_congbo != null && temp_congbo.TRANGTHAI != 2 && temp_congbo.TRANGTHAI != 3)
                    {
                        temp_congbo.NGAYSUA = DateTime.Now;
                        temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Update(temp_congbo);
                    }
                }

                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControl();

                Capnhat_AHS_TONGHOPHINHPHAT();

                lbThongBaoQD.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbThongBaoQD.Text = ex.Message;
            }
        }
        protected void AsyncFileUpLoad_UploadedCompleteQD(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoadQD.HasFile)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoadQD.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoadQD.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePathQD.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lbThongBaoQD.Text = "chỉ lưu file .doc";
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = "Lỗi: " + ex.Message; }
        }
        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PT(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, ID);
            if (oDT != null)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndataQD.Visible = true;
            }
            else
            {
                pndataQD.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                pnHinhThucXetXu.Visible = false;
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                List<AHS_PHUCTHAM_QUYETDINH_VUAN> lstQD = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.LOAIQDID == 3 || x.LOAIQDID == 15 || x.QUYETDINHID != 204 || x.QUYETDINHID != 205)).ToList();
                if (lstQD.Count >= 1)
                {
                    Cls_Comon.SetButton(btnUpdate, false);
                }
                ResetControl();
            }
            catch (Exception ex) { }
        }
        public void xoa(decimal id)
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            // check đồng bộ dữ liệu chưa
            KHOBAQD_BL obl = new KHOBAQD_BL();
            bool isExist = obl.IsExistKHOBADQ(1, VuAnID, 3, ENUM_LOAIVUVIEC_TEXT.AN_HINHSU);

            if (isExist)
            {
                lbThongBaoQD.Text = "Vụ án đã được đồng bộ, phải thu hồi trước khi xóa !";
                return;
            }

            AHS_PHUCTHAM_QUYETDINH_VUAN oND = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                {
                    lbThongBaoQD.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
                    return;
                }
                if (oND.LOAIQDID == 3)
                {
                    AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (objAn != null)
                    {
                        //objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        objAn.NGAYSUA = DateTime.Now;
                        objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                }
                AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (file != null)
                {
                    dt.AHS_FILE.Remove(file);
                }
                dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Remove(oND);
                dt.SaveChanges();
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
                                                                    $"  AND CAPXETXU = {3} ");

            BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
            if (temp_congbo != null)
            {
                temp_congbo.BAQDID = 0;
                temp_congbo.NGAYHIEULUC = null;
                temp_congbo.NGAYSUA = DateTime.Now;
                temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(temp_congbo);
            }

            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControl();
            lbThongBaoQD.Text = "Xóa thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        public void loadedit(decimal ID)
        {
            lbThongBaoQD.Text = "";
            AHS_PHUCTHAM_QUYETDINH_VUAN oND = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
            hddidQD.Value = oND.ID.ToString();
            decimal IDQD = Convert.ToDecimal(oND.QUYETDINHID);
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            Cls_Comon.SetButton(btnUpdate, true);

            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
            if (oND.QUYETDINHID != null)
            {
                ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            }
            LoadLydo();
            LoadHTXX();

            if (oND.QUYETDINHID == 201 || oND.QUYETDINHID == 202)
            {
                lbtxtLydo.InnerText = "Lý do";
                pntxtLydo.Visible = true;

                if (oND.LYDO_NAME != null)
                {
                    txtLydo.Text = oND.LYDO_NAME;
                }
                else if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                    txtLydo.Text = ddlLydo.SelectedItem.Text;
                }
            }
            else if (oND.LYDOID != null && pnLyDo.Visible)
            {
                lbtxtLydo.InnerText = "";
                ddlLydo.SelectedValue = oND.LYDOID.ToString();
            }
            
            if (ddlQuyetdinh.SelectedItem.Text.Contains("46-HS"))
            {
                if (oND.KETQUAID != 0 && oND.KETQUAID != null)
                {
                    pnKetquaPhuctham.Visible = true;
                    LoadDropKetQuaQuyetdinhPhuctham();
                    ddlKetquaQuyetdinh.SelectedValue = oND.KETQUAID.ToString();

                    LoadDropLyDoQuyetdinh();
                    if (oND.LYDOKETQUAID != 0 && oND.LYDOKETQUAID != null)
                    {
                        pnLyDoKetquaPhuctham.Visible = true;
                        ddlLydoQuyetdinh.SelectedValue = oND.LYDOKETQUAID.ToString();
                    }
                }
            }
            else
            {
                if(pnKetquaPhuctham.Visible == true)
                {
                    ddlKetquaQuyetdinh.SelectedIndex = 0;
                    if (pnLyDoKetquaPhuctham.Visible == true)
                    {
                        ddlLydoQuyetdinh.SelectedIndex = 0;
                    }
                }
                pnKetquaPhuctham.Visible = false;
                pnLyDoKetquaPhuctham.Visible = false;
            }
            //công bố quyết định
            if (oND.ISCONGBOQD != null)
                rdCongBoQD.SelectedValue = oND.ISCONGBOQD.ToString();
            txtSoQD.Text = oND.SOQUYETDINH;
            txtNgayQD.Text = string.IsNullOrEmpty(oND.NGAYQD + "") ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            txtHieulucTuNgay.Text = string.IsNullOrEmpty(oND.HIEULUCTU + "") ? "" : ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            txtHieuLucDenNgay.Text = string.IsNullOrEmpty(oND.HIEULUCDEN + "") ? "" : ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (txtHieuLucDenNgay.Text == "")
            {
                decimal QDID = oND.QUYETDINHID + "" == "" ? 0 : (decimal)oND.QUYETDINHID;
                DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == QDID).FirstOrDefault();
                if (oT != null)
                {
                    hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                    hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
                }
            }
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == oND.NGUOIKYID).FirstOrDefault<DM_CANBO>();
            decimal qdID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            if (cbo != null)
            {
                LoadNguoiKyDdlInfo();
                //Check người ký theo loại QĐ:
                if (qdID == 201 || qdID == 202 || qdID == 77 || qdID == 78 || qdID == 161 || qdID == 162 || qdID == 163 || qdID == 127 || qdID == 203)
                {
                    ddlNguoiky.SelectedValue = oND.NGUOIKYID.ToString();
                    phNguoiKyDdl.Visible = true;
                    phNguoiKyTxt.Visible = false;
                }
                else
                {
                    txtNguoiKyQDVV.Text = cbo.HOTEN;
                    txtChucvu.Text = oND.CHUCVU;
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                switch (e.CommandName)
                {
                    case "DownloadQD":
                        AHS_PHUCTHAM_QUYETDINH_VUAN oND = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        AHS_PHUCTHAM_QUYETDINH_VUAN oND1 = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND1 != null)
                        {
                            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                            AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == oND1.VUANID && x.MAPID == ND_id && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_PHUCTHAM_QUYETDINH_VUAN).FirstOrDefault();
                            if (oTD != null)
                            {
                                lbThongBaoQD.Text = "Bạn không thể sửa khi đã tống đạt!";
                                return;
                            }
                        }
                        loadedit(ND_id);
                        hddidQD.Value = e.CommandArgument.ToString();
                        Capnhat_AHS_TONGHOPHINHPHAT();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbThongBaoQD.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        if (hddIsSuaDoi.Value == "0")
                        {
                            lbThongBaoQD.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
                            return;
                        }
                        AHS_PHUCTHAM_QUYETDINH_VUAN oND2 = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND2 != null)
                        {
                            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                            AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == oND2.VUANID && x.MAPID == ND_id && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_PHUCTHAM_QUYETDINH_VUAN).FirstOrDefault();
                            if (oTD != null)
                            {
                                lbThongBaoQD.Text = "Bạn không thể xóa khi đã tống đạt!";
                                return;
                            }
                        }
                        bool isCongbo = CheckCongbo(VuAnID);
                        if (!isCongbo)
                        {
                            lbThongBaoQD.Text = "Vụ việc đã có thông tin công bố. Không được xóa.";
                            return;
                        }
                        xoa(ND_id);
                        Capnhat_AHS_TONGHOPHINHPHAT();
                        break;
                    
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                
                //Check quyết định sửa chữa, bổ sung bản án
                CheckQuyen();

                if (btnUpdate.Enabled == true)
                {
                    if (oT.LOAIID == 2 /*Chuyển vụ án*/ || oT.TEN.Contains("cho Thẩm phán") || oT.ID == 422 /*19-VDS. Quyết định đình chỉ việc xét đơn yêu cầu giải quyết việc dân sự*/ )
                    {
                        lbThongBaoQD.Text = "";
                        Cls_Comon.SetButton(btnUpdate, true);
                    }
                    else
                    {
                        AHS_PHUCTHAM_QUYETDINH_VUAN QDST = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.LOAIQDID == 5 && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/).OrderByDescending(x => x.NGAYQD).FirstOrDefault();
                        if (QDST == null)
                        {
                            lbThongBaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                            Cls_Comon.SetButton(btnUpdate, false);
                            return;
                        }
                    }
                }

                if (ID == 77 || ID == 78 || ID == 79 || ID == 80 || ID == 128 || ID == 206 || ID == 4 || ID == 61)
                {
                    // lấy số mới nhất 
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD;
                    if (txtNgayQD.Text != "")
                        ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else
                        ngayQD = DateTime.Now;
                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS", ngayQD, ID).ToString();
                    txtSoQD.Text = STTNew;
                }
                //Đổi Người ký với các loại QĐ 43,44,39,, 40, 04, 05, 06
                if (ID == 201 || ID == 202 || ID == 77 || ID == 78 || ID == 161 || ID == 162 || ID == 163 || ID == 203 || ID == 127)
                {
                    LoadNguoiKyDdlInfo();
                    phNguoiKyDdl.Visible = true;
                    phNguoiKyTxt.Visible = false;
                }
                else
                {
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
                LoadLydo();
                LoadHTXX();

                if (ddlQuyetdinh.SelectedItem.Text == "46-HS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với Quyết định tạm đình chỉ (đình chỉ) vụ án")
                {
                    pnKetquaPhuctham.Visible = true;
                    LoadDropKetQuaQuyetdinhPhuctham();
                }
                else
                {
                    pnKetquaPhuctham.Visible = false;
                    pnLyDoKetquaPhuctham.Visible = false;
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }
        protected void txtHieulucTuNgay_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (txtHieulucTuNgay.Text != "")
                {
                    DateTime dFrom = DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (dFrom != DateTime.MinValue)
                    {
                        int SoThangTheoLuat = Convert.ToInt32(hddThoiHanThang.Value), SoNgayTheoLuat = Convert.ToInt32(hddThoiHanNgay.Value);
                        dFrom = dFrom.AddMonths(SoThangTheoLuat);
                        dFrom = dFrom.AddDays(SoNgayTheoLuat);
                        txtHieuLucDenNgay.Text = dFrom.ToString("dd/MM/yyyy", cul);
                    }
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }
        private decimal UploadFileID(decimal VuAnID, decimal FileID, string strMaBieumau)
        {
            decimal IDFIle = 0, IDBM = 0;
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
                if (lstBM.Count > 0)
                {
                    IDBM = lstBM[0].ID;
                }
                bool isNew = false;
                //vnpt chinh luu file  4/12/2025
                //AHS_FILE objFile = dt.AHS_FILE.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && x.BIEUMAUID == IDBM).FirstOrDefault();
                AHS_FILE objFile = new AHS_FILE();
                if (FileID > 0)
                {
                    isNew = false;
                    objFile = dt.AHS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                }
                else
                {
                    isNew = true;
                    objFile = new AHS_FILE();
                }
                objFile.VUANID = VuAnID;
                objFile.TOAANID = oVuAn.TOAANID;
                objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                objFile.LOAIFILE = 0;
                objFile.BIEUMAUID = IDBM;
                objFile.NAM = DateTime.Now.Year;
                objFile.NGAYTAO = DateTime.Now;
                objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (hddFilePathQD.Value != "")
                {
                    try
                    {
                        string strFilePath = "";

                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            objFile.NOIDUNG = buff;
                            objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            objFile.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
                }
                if (isNew)
                {
                    dt.AHS_FILE.Add(objFile);
                }
                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            return IDFIle;
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }
            }
        }

        #endregion

        #region Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án
        protected void ddlKetquaQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0" || ddlKetquaQuyetdinh.SelectedValue == "101")
                {
                    ddlLydoQuyetdinh.Items.Clear();
                    pnLyDoKetquaPhuctham.Visible = false;
                }
                else
                {
                    pnLyDoKetquaPhuctham.Visible = true;
                    LoadDropLyDoQuyetdinh();
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }
        private void LoadDropKetQuaQuyetdinhPhuctham()
        {
            ddlKetquaQuyetdinh.Items.Clear();
            ddlKetquaQuyetdinh.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISAHS == 1 && x.ISQUYETDINH == 1).OrderBy(y => y.THUTU).ToList();
            ddlKetquaQuyetdinh.DataTextField = "TEN";
            ddlKetquaQuyetdinh.DataValueField = "ID";
            ddlKetquaQuyetdinh.DataBind();
            ddlKetquaQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropLyDoQuyetdinh()
        {
            ddlLydoQuyetdinh.Items.Clear();
            decimal KetQuaID = Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue);
            DM_KETQUA_PHUCTHAM_LYDO_BL kqptLyDoBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable dtTable = kqptLyDoBL.DM_KETQUA_PT_LYDO_GETLIST(KetQuaID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                ddlLydoQuyetdinh.DataSource = dtTable;
                ddlLydoQuyetdinh.DataTextField = "TEN";
                ddlLydoQuyetdinh.DataValueField = "ID";
                ddlLydoQuyetdinh.DataBind();
            }
            ddlLydoQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        #endregion

        private void Capnhat_AHS_TONGHOPHINHPHAT()
        {
            try
            {
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_TONGHOPHINHPHAT saveTHHP = new AHS_TONGHOPHINHPHAT();

                List<AHS_PHUCTHAM_BICANBICAO> lstTL = dt.AHS_PHUCTHAM_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_PHUCTHAM_BICANBICAO>();
                foreach (var item in lstTL)
                {
                    if (!saveTHHP.Capnhat_Tonghophinhphat_byVuanAndBicanid(3, VuAnID, item.ID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                    {
                        AHS_BICANBICAO lstTL1 = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.ID == item.BICANID).FirstOrDefault<AHS_BICANBICAO>();
                        lttMsgBanAn.Text = lbThongBaoQD.Text = "Lỗi Tổng hợp hình phạt!" + "(" + lstTL1.HOTEN + ")";
                        return;
                    }
                }
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Lỗi Tổng hợp hình phạt!";
                return;
            }
        }

        protected void Load_txbSoBiCao_PhapNhan()
        {
            txtDuyetKN_VKS.Visible = rdDuyetKhangNghiVKS.SelectedValue == "1";
            txtSuaHinhPhatBS.Visible = rdSuaHinhPhatBS.SelectedValue == "1";
            txtSuaBoiThuongTH.Visible = rdSuaBoiThuongTH.SelectedValue == "1";
            txtSuaKhac.Visible = rdSuaKhac.SelectedValue == "1";
            txtSuaQDAnSoTham.Visible = rdSuaQDAnSoTham.SelectedValue == "1";
            txtViPhamHan.Visible = rdViPhamHan.SelectedValue == "1";
        }

        protected void rdSuaHinhPhatBS_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_txbSoBiCao_PhapNhan();
        }

        protected void rdSuaBoiThuongTH_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_txbSoBiCao_PhapNhan();
        }

        protected void rdSuaKhac_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_txbSoBiCao_PhapNhan();
        }

        protected void rdSuaQDAnSoTham_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_txbSoBiCao_PhapNhan();
        }
        protected void rdDuyetKhangNghiVKS_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_txbSoBiCao_PhapNhan();
        }
        
        protected void rdViPhamHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_txbSoBiCao_PhapNhan();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion
        protected void LoadListToiDanh_ByVuAnId()
        {
            var VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            var listToiDanhST = (
                from va in dt.AHS_VUAN
                join bc in dt.AHS_BICANBICAO on va.ID equals bc.VUANID
                join ba_dct in dt.AHS_SOTHAM_BANAN_DIEU_CHITIET on bc.ID equals ba_dct.BICANID into ba_dct_left
                from ba_dct in ba_dct_left.DefaultIfEmpty()
                join ct in dt.AHS_SOTHAM_CAOTRANG_DIEULUAT on bc.ID equals ct.BICANID into ct_left
                from ct in ct_left.DefaultIfEmpty()
                join td in dt.DM_BOLUAT_TOIDANH on (ba_dct.TOIDANHID != null ? ba_dct.TOIDANHID : ct.TOIDANHID) equals td.ID
                join kn in dt.AHS_SOTHAM_KHANGNGHI on va.ID equals kn.VUANID into knLeft
                from kn in knLeft.DefaultIfEmpty()
                where va.ID == VuAnID
                    && td.KHOAN == null
                    && (
                        (kn.DSNGUOIBIKN != null && kn.DSNGUOIBIKN.Contains(bc.ID.ToString()))
                        || (kn.DSNGUOIBIKN == null && kn.VUANID != null)
                        || dt.AHS_SOTHAM_KHANGCAO.Any(kc => kc.NGUOIKCID == bc.ID)
                        )
                select new
                {
                    ID = td.ID,
                    TENTOIDANH = td.TENTOIDANH,
                })
                .Distinct()
                .ToList();

            var listToiDanhPT = (
                from ba in dt.AHS_PHUCTHAM_BANAN
                join ba_dct in dt.AHS_PHUCTHAM_BANAN_DIEU_CT on ba.ID equals ba_dct.BANANID
                join td in dt.DM_BOLUAT_TOIDANH on ba_dct.TOIDANHID equals td.ID
                where ba.VUANID == VuAnID
                    && td.KHOAN == null
                select new
                {
                    ID = td.ID,
                    TENTOIDANH = td.TENTOIDANH,
                })
                .Distinct()
                .ToList();

            ddlToiDanhVuAn.Items.Clear();
            ddlToiDanhVuAn.Items.Add(new ListItem("-- Chọn tội danh --", "0"));
            if (listToiDanhPT.Count > 0)
            {
                foreach (var item in listToiDanhPT)
                    ddlToiDanhVuAn.Items.Add(new ListItem { Text = item.TENTOIDANH, Value = item.ID.ToString() });
            }
            else
            {
                foreach (var item in listToiDanhST)
                    ddlToiDanhVuAn.Items.Add(new ListItem { Text = item.TENTOIDANH, Value = item.ID.ToString() });
            }
            ddlToiDanhVuAn.SelectedIndex = 0;
        }
    }
}

