using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHS;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.AHS.PhucThamQDK
{
    public partial class ThuLy : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public decimal VuAnID = 0;
        public decimal VuAnIDST = 0;
        private Decimal PhongBanID = 0, CurrDonViID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                lstMsgB.Text = "";
                txtTuNgay.Enabled = false;
                if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                {
                    VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                    AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
                    VuAnIDST = _chuyenNhanBl.getDonIdOld(VuAnID);
                    CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (!IsPostBack)
                    {
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                        Cls_Comon.SetButton(cmdThemmoi, oPer.CAPNHAT);
                        LoadThongTin_XetXuSoTham();
                        CheckQuyen();
                        LoadNguoiKyDdlInfo();
                        LoadGrid();
                        if (rpt.Items.Count == 0)
                        {
                            SetNew_SoThuLy();
                        }
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex) {
                lstMsgB.Text = ex.Message;
                logger.Error("loi xay ra: " + ex);
            }
        }

        private void CheckQuyen()
        {
            //Kiểm tra có kháng cáo, kháng nghị hay không?
            //AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            //if (oT != null)
            //{
            //    AHS_SOTHAM_BL objST = new AHS_SOTHAM_BL();
            //    DataTable tbl = objST.AHS_SOTHAM_KCaoKNghi_GETLIST(VuAnID);
            //    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && tbl.Rows.Count == 0)
            //    {
            //        lstMsgB.Text = "Chưa có kháng cáo/ kháng nghị !";
            //        Cls_Comon.SetButton(cmdUpdate, false);
            //        Cls_Comon.SetButton(cmdThemmoi, false);
            //        hddIsShowCommand.Value = "False";
            //        return;
            //    }

            //    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            //    {
            //        lstMsgB.Text = "Vụ án đã được chuyển lên tòa án cấp trên. Không được sửa đổi !";
            //        Cls_Comon.SetButton(cmdUpdate, false);
            //        Cls_Comon.SetButton(cmdThemmoi, false);
            //        hddIsShowCommand.Value = "False";
            //        return;
            //    }
            //    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            //    {
            //        lstMsgB.Text = "Vụ án đã được chuyển xét xử lại cấp sơ thẩm. Không được sửa đổi !";
            //        Cls_Comon.SetButton(cmdUpdate, false);
            //        Cls_Comon.SetButton(cmdThemmoi, false);
            //        hddIsShowCommand.Value = "False";
            //        return;
            //    }
            //}
            //AHS_KCKNQDK_PHUCTHAM_BANAN ba =DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            //if (ba != null && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            //{
            //    lstMsgB.Text = "Vụ án đã có bản án phúc thẩm. Không được sửa đổi !";
            //    Cls_Comon.SetButton(cmdUpdate, false);
            //    Cls_Comon.SetButton(cmdThemmoi, false);
            //    hddIsShowCommand.Value = "False";
            //    return;
            //}

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }

            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable QDKetThuc = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
            if (QDKetThuc != null && QDKetThuc.Rows.Count > 0)
            {
                lstMsgB.Text = "Đã có kết quả phúc thẩm , Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            List<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST> listMapkckn = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST>($"VUANPT_ID = {VuAnID} AND TRANG_THAI_ID = 0").ToList();
            if (listMapkckn != null && listMapkckn.Count > 0)
            {
                pnGopTach.Visible = true;
            }
        }

        //------------------------------
        private void LoadThongTin_XetXuSoTham()
        {
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            LoadToaSoTham();
            LoadGrid_KhangCao();
            LoadGrid_KhangNghi();

            ddTruongHopTL.Items.Clear();
            AHS_CHUYEN_NHAN_AN oCN = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == VuAnID && x.TOANHANID == CurrDonViID).SingleOrDefault<AHS_CHUYEN_NHAN_AN>();
            if (oCN.TRUONGHOPGIAONHANID == 998)
            {
                ddTruongHopTL.Items.Add(new ListItem("Do giám đốc thẩm hủy để xét xử lại phúc thẩm", "AHS_PT_ThuLyLai"));
            }
            else if ((pnKC.Visible == true && pnKN.Visible == true) || (oCN.TRUONGHOPGIAONHANID == 267 && oCN.TRUONGHOPGIAONHANID == 269))
                ddTruongHopTL.Items.Add(new ListItem("Do có kháng cáo và kháng nghị phúc thẩm", "AHS_PT_ThuLyKCKN"));
            else
            {
                if (pnKC.Visible == true || oCN.TRUONGHOPGIAONHANID == 267)
                    ddTruongHopTL.Items.Add(new ListItem("Do có kháng cáo phúc thẩm", "AHS_PT_ThuLyKC"));
                else if (pnKN.Visible == true || oCN.TRUONGHOPGIAONHANID == 269)
                    ddTruongHopTL.Items.Add(new ListItem("Do có kháng nghị phúc thẩm", "AHS_PT_ThuLyKN"));
            }
        }

        private void LoadToaSoTham()
        {
            AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == VuAnIDST).FirstOrDefault();
            if (obj != null)
            {
                AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnIDST).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (oBA != null)
                {
                    lblBAQD.Text = "Số BA:<b>" + oBA.SOBANAN + "</b>";
                    string ngayBA = (((DateTime)oBA.NGAYBANAN) == DateTime.MinValue) ? "" : ((DateTime)oBA.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    lblNgayBAQD.Text = "Ngày BA:<b>" + ngayBA + "</b>";
                }
                else
                {
                    AHS_SOTHAM_QUYETDINH_VUAN objQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnIDST).FirstOrDefault();
                    if (objQD != null)
                    {
                        lblBAQD.Text = "Số QĐ:<b>" + objQD.SOQUYETDINH + "</b>";
                        string ngayba = (((DateTime)objQD.NGAYQD) == DateTime.MinValue) ? "" : ((DateTime)objQD.NGAYQD).ToString("dd/MM/yyyy", cul);
                        lblNgayBAQD.Text = " Ngày QĐ:<b>" + ngayba + "</b>";
                    }
                }
                if (obj.TOAANID > 0)
                {
                    DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANID).First();
                    lblToaxx.Text = oT.TEN;
                }
            }

            AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
            DataTable tbl = objBL.GetAllPaging(VuAnIDST, null, 1, 100);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptToaSoTham.DataSource = tbl;
                rptToaSoTham.DataBind();
                rptToaSoTham.Visible = true;
            }
            else
                rptToaSoTham.Visible = false;
        }

        public void LoadGrid_KhangCao()
        {
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.AHS_GETKCSOTHAM_XULY(VuAnID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                rptKC.DataSource = oDT;
                rptKC.DataBind();
                pnKC.Visible = true;
            }
            else pnKC.Visible = false;
        }

        public void LoadGrid_KhangNghi()
        {
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.AHS_GETKNSOTHAM_XULY(VuAnID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                rptKN.DataSource = oDT;
                rptKN.DataBind();
                pnKN.Visible = true;
            }
            else pnKN.Visible = false;
        }

        private void LoadNguoiKyDdlInfo()
        {
            DataTable tbl = null;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            //Lấy danh sách Chánh án, phó chánh án, Chánh VP, Phó chánh VP, Thẩm phán
            tbl = cb_BL.DM_CANBO_GETBYDONVI_THULY(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
        }

        //------------------------------
        private void LoadInfo(decimal ThuLyID)
        {
            lstMsgB.Text = "";
            AHS_KCKNQDK_PHUCTHAM_THULY obj = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_THULY>(ThuLyID);
            if (obj != null)
            {
                txtNgayThuLy.Text = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                txtSoThuLy.Text = obj.SOTHULY + "";

                if (obj.THOIHANTUNGAY != null)
                {
                    txtTuNgay.Text = (DateTime)obj.THOIHANTUNGAY == DateTime.MinValue ? "" : ((DateTime)obj.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                }

                if (obj.THOIHANDENNGAY != null)
                {
                    txtDenNgay.Text = (DateTime)obj.THOIHANDENNGAY == DateTime.MinValue ? "" : ((DateTime)obj.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                }

                //txtSoNgay.Text =  obj.THOIHAN_NGAY.ToString();
                //txtSoThang.Text = obj.THOIHAN_THANG.ToString();
                if (obj.UTTPDI == 1)
                    cbUTTP.Checked = true;
                else
                    cbUTTP.Checked = false;

                DM_DATAITEM objDM = dt.DM_DATAITEM.Where(x => x.ID == obj.TRUONGHOPTHULY).FirstOrDefault();
                ddTruongHopTL.SelectedValue = objDM.MA.ToString();
                ddlNguoiky.SelectedValue = obj.NGUOIKYID + "";
            }
        }

        //void LoadDrop()
        //{
        //    DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        //    DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAITHULY_AHS_PT);

        //    ddTruongHopTL.Items.Clear();
        //    if (tbl != null && tbl.Rows.Count > 0)
        //    {
        //        foreach (DataRow row in tbl.Rows)
        //            ddTruongHopTL.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
        //    }
        //}
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;
            //------------------------------
            //Decimal ThuLyID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            //DateTime NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //String sothuly = txtSoThuLy.Text.Trim();
            //AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            //Boolean IsExist = objBL.CheckExistSoThuLy(ThuLyID,sothuly, NGAYTHULY);
            //if (IsExist)
            //{
            //    lstMsgB.Text = "Đã có số thụ lý này. Đề nghị kiểm tra lại";
            //    return;
            //}
            //else
            //{
            Save();

            ResetForm();
            hddPageIndex.Value = "1";
            LoadGrid();
            //}
        }

        protected void btnGop_Click(object sender, EventArgs e)
        {
            List<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST> listMapkckn = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST>($"VUANPT_ID = {VuAnID} AND TRANG_THAI_ID = 0").ToList();
            if (listMapkckn != null && listMapkckn.Count > 0)
            {
                foreach (var item in listMapkckn)
                {
                    item.TRANG_THAI_ID = 1;
                    DataExtensions.Update(item);
                }
            }
            pnGopTach.Visible = false;
        }

        protected void btnTach_Click(object sender, EventArgs e)
        {
            List<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST> listMapkckn = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST>($"VUANPT_ID = {VuAnID} AND TRANG_THAI_ID = 0").ToList();
            if (listMapkckn != null && listMapkckn.Count > 0)
            {
                var listGroup = listMapkckn.Select(x => x.NHANANID).Distinct().ToList();
                foreach (var item in listGroup)
                {
                    var ChuyenNhanAnID = item;
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    AHS_CHUYEN_NHAN_AN oT = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanAnID).FirstOrDefault();

                    #region tạo mới đơn trên phúc thẩm tđc

                    AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnIDST).FirstOrDefault();
                    AHS_VUAN oVUAN_new = new AHS_VUAN();

                    oVUAN_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oVUAN_new.VKSID = oVuAn.VKSID;
                    oVUAN_new.TRUONGHOPGIAONHAN = oT.TRUONGHOPGIAONHANID;
                    oVUAN_new.SOBANCAOTRANG = oVuAn.SOBANCAOTRANG;
                    oVUAN_new.NGAYBANCAOTRANG = oVuAn.NGAYBANCAOTRANG;
                    oVUAN_new.SOBUTLUC = oVuAn.SOBUTLUC;
                    oVUAN_new.NGAYGIAO = oVuAn.NGAYGIAO;
                    oVUAN_new.QUYETDINHTRUYTO = oVuAn.QUYETDINHTRUYTO;

                    oVUAN_new.TENVUAN = oVuAn.TENVUAN;
                    oVUAN_new.TENKHAC = oVuAn.TENKHAC;
                    oVUAN_new.SOBICAN = oVuAn.SOBICAN;
                    oVUAN_new.SOBICANTAMGIAM = oVuAn.SOBICANTAMGIAM;
                    oVUAN_new.LOAITOIPHAMID = oVuAn.LOAITOIPHAMID;
                    oVUAN_new.NGAYXAYRA = oVuAn.NGAYXAYRA;
                    oVUAN_new.THANGXAYRA = oVuAn.THANGXAYRA;
                    oVUAN_new.NAMXAYRA = oVuAn.NAMXAYRA;
                    oVUAN_new.GIOXAYRA = oVuAn.GIOXAYRA;
                    oVUAN_new.GHICHU = oVuAn.GHICHU;
                    oVUAN_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oVUAN_new.NGAYTAO = DateTime.Now;
                    AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                    oVUAN_new.TT = dsBL.GETNEWTT((decimal)oVUAN_new.TOAANID);
                    //oVUAN_new.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + oVUAN_new.TT.ToString();
                    oVUAN_new.MAVUAN = oVuAn.MAVUAN;
                    oVUAN_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM_QDK;
                    oVUAN_new.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oVUAN_new.ID_HO_SO_FROM_TOA_CAP_CAO = oVuAn.ID_HO_SO_FROM_TOA_CAP_CAO;
                    oVUAN_new.TOAAN_CHUYEN_ID = oVuAn.TOAAN_CHUYEN_ID;
                    // insert toa_gq_id
                    oVUAN_new.TOA_GIAIQUYET_ID = oVuAn.TOA_GIAIQUYET_ID;
                    // insert toa_pt_gq_id
                    oVUAN_new.TOA_PHUCTHAM_GIAIQUYET_ID = oVuAn.TOA_PHUCTHAM_GIAIQUYET_ID;
                    dt.AHS_VUAN.Add(oVUAN_new);
                    dt.SaveChanges();

                    GD.GAIDOAN_INSERT_UPDATE("1", oVUAN_new.ID, ENUM_GIAIDOANVUAN.PHUCTHAM_QDK, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);

                    oT.MAP_VUANID_NEW = oVUAN_new.ID;
                    List<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST> listKCKN = listMapkckn.Where(x => x.NHANANID == ChuyenNhanAnID).ToList();
                    foreach (var mapkckn in listKCKN)
                    {
                        AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST obnew = new AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST()
                        {
                            IS_KC = mapkckn.IS_KC,
                            KCKN_SOTHAM_ID = mapkckn.KCKN_SOTHAM_ID,
                            NGAY_TAO = DateTime.Now,
                            NHANANID = ChuyenNhanAnID,
                            TRANG_THAI_ID = 1,
                            VUANPT_ID = oVUAN_new.ID,
                            VUANST_ID = oVuAn.ID
                        };
                        DataExtensions.Insert(obnew);
                        DataExtensions.Delete(mapkckn);
                    }

                    #endregion tạo mới đơn trên phúc thẩm tđc
                }
            }

            pnGopTach.Visible = false;
        }

        private void Save()
        {
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            Boolean IsNew = false;
            AHS_KCKNQDK_PHUCTHAM_THULY obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {VuAnId} AND TOA_GIAIQUYET_ID = {Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])}").FirstOrDefault();
            if (obj == null)
            {
                IsNew = true;
                obj = new AHS_KCKNQDK_PHUCTHAM_THULY();
            }
            obj.VUANID = VuAnId;
            obj.TOAANID = ToaAnID;
            obj.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);

            if (ddTruongHopTL.SelectedValue == "AHS_PT_ThuLyLai")
            {
                obj.TRUONGHOPTHULY = 998;
            }
            else
            {
                DM_DATAITEM objDM = dt.DM_DATAITEM.Where(x => x.MA == ddTruongHopTL.SelectedValue).FirstOrDefault();
                obj.TRUONGHOPTHULY = objDM.ID;
            }
            obj.SOTHULY = txtSoThuLy.Text.Trim();
            //-----------------------------------------
            DateTime date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTHULY = date_temp;
            obj.THOIHANTUNGAY = obj.NGAYTHULY;
            //-------------------------------
            date_temp = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.Now.AddDays(15) : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.THOIHANDENNGAY = date_temp;
            if (cbUTTP.Checked)
                obj.UTTPDI = 1;
            else
                obj.UTTPDI = 0;
            AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            if (IsNew)
            {
                decimal ToaID = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                decimal STT = objBL.GETNEWTT(ToaID, NgayThuLy);
                obj.TT = STT;

                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                DataExtensions.Insert(obj);

                // update giai đoạn vụ án
                AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnId).FirstOrDefault<AHS_VUAN>();
                if (objAn != null)
                    objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM_QDK;
                //anhvh add 26/06/2020
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("1", VuAnId, ENUM_GIAIDOANVUAN.PHUCTHAM_QDK, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (obj != null && obj.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                {
                    lstMsgB.Text = "Không có quyền sửa thụ lý này.";
                    return;
                }
                DataExtensions.Update(obj);
            }

            //--------------------
            GanBiCaoThamGiaPT();
            DataTable tbl = objBL.GetAllByVuAnIDTDC(VuAnId);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    decimal bicanid = Convert.ToDecimal(row["BiCaoID"].ToString());

                    AHS_KCKNQDK_PHUCTHAM_BICANBICAO biCanPt = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO();
                    biCanPt.BICANID = bicanid;
                    biCanPt.VUANID = VuAnID;
                    biCanPt.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    biCanPt.NGAYTAO = DateTime.Now;
                    DataExtensions.Insert(biCanPt);
                }
            }
            lstMsgB.Text = "Lưu dữ liệu thành công!";
        }

        private void GanBiCaoThamGiaPT()
        {
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnIDST).ToList();
            List<AHS_NGUOITHAMGIATOTUNG> lstTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnIDST).ToList();
            //AHS_SOTHAM_BANAN bananidST = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnIDST).FirstOrDefault();
            //List<AHS_SOTHAM_KHANGNGHI> lstKN = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnIDST && x.BANANID == bananidST.ID).ToList();

            bool checkKCKN = false;
            //try
            //{
            //    if (lstKN != null && lstKN.Count > 0)
            //    {
            //        checkKCKN = true;
            //    }
            //    else
            //    {
            //        if (lstTGTT != null && lstTGTT.Count > 0)
            //        {
            //            foreach (AHS_NGUOITHAMGIATOTUNG item in lstTGTT)
            //            {
            //                AHS_SOTHAM_KHANGCAO tgttKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnIDST && x.NGUOIKCID == item.ID).FirstOrDefault();
            //                if (tgttKC != null)
            //                {
            //                    checkKCKN = true;
            //                }
            //            }
            //        }
            //    }
            //}
            //catch (Exception ex) { }

            if (checkKCKN)
            {
                if (lst != null && lst.Count > 0)
                {
                    AHS_KCKNQDK_PHUCTHAM_BICANBICAO obj = null;
                    Boolean isnew = true;
                    foreach (AHS_BICANBICAO item in lst)
                    {
                        try
                        {
                            try
                            {
                                obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_BICANBICAO>($"VUANID = {VuAnID} AND BICANID = {item.ID}").Single();
                                if (obj != null)
                                    isnew = false;
                                else
                                    obj = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO();
                            }
                            catch (Exception ex) { obj = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO(); }
                            obj.BICANID = item.ID;
                            obj.VUANID = VuAnID;

                            if (isnew)
                            {
                                obj.NGUOITAO = curr_user;
                                obj.NGAYTAO = DateTime.Now;
                                DataExtensions.Insert(obj);
                            }
                            else
                            {
                                DataExtensions.Update(obj);
                            }
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
            }
            else
            {
                if (lst != null && lst.Count > 0)
                {
                    AHS_KCKNQDK_PHUCTHAM_BICANBICAO obj = null;
                    Boolean isnew = true;
                    foreach (AHS_BICANBICAO item in lst)
                    {
                        try
                        {
                            try
                            {
                                obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_BICANBICAO>($"VUANID = {VuAnID} AND BICANID = {item.ID}").Single<AHS_KCKNQDK_PHUCTHAM_BICANBICAO>();
                                if (obj != null)
                                    isnew = false;
                                else
                                    obj = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO();
                            }
                            catch (Exception ex) { obj = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO(); }

                            AHS_SOTHAM_KHANGCAO bcKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.NGUOIKCID == item.ID).FirstOrDefault();
                            if (bcKC != null)
                            {
                                obj.BICANID = item.ID;
                                obj.VUANID = VuAnID;

                                if (isnew)
                                {
                                    obj.NGUOITAO = curr_user;
                                    obj.NGAYTAO = DateTime.Now;
                                    DataExtensions.Insert(obj);
                                }
                                else
                                {
                                    DataExtensions.Update(obj);
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
            }
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            txtTuNgay.Text = txtNgayThuLy.Text;
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]), LoaiToiPhamID = 0;
            DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            // số thụ lý
            SetNew_SoThuLy();

            AHS_VUAN vuan = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
            if (vuan != null)
            {
                LoaiToiPhamID = vuan.LOAITOIPHAMID + "" == "" ? 0 : (decimal)vuan.LOAITOIPHAMID;
            }
            DM_DATAITEM dmLoaiToiPham = dt.DM_DATAITEM.Where(x => x.ID == LoaiToiPhamID && x.HIEULUC == 1).FirstOrDefault<DM_DATAITEM>();
            if (dmLoaiToiPham != null)
            {
                string MaLoaiTP = dmLoaiToiPham.MA;
                txtDenNgay.Enabled = false;
                if (NgayThuLy != DateTime.MinValue)
                {
                    switch (MaLoaiTP)
                    {
                        case ENUM_AHS_LOAITOIPHAM.IT_NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddDays(30)).ToString("dd/MM/yyyy", cul);
                            break;

                        case ENUM_AHS_LOAITOIPHAM.NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddDays(45)).ToString("dd/MM/yyyy", cul);
                            break;

                        case ENUM_AHS_LOAITOIPHAM.RAT_NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddMonths(2)).ToString("dd/MM/yyyy", cul);
                            break;

                        case ENUM_AHS_LOAITOIPHAM.DACBIET_NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddMonths(3)).ToString("dd/MM/yyyy", cul);
                            break;

                        default:
                            txtDenNgay.Enabled = true;
                            break;
                    }
                }
                else
                    txtDenNgay.Enabled = true;
            }
            // số thụ lý
            // SetNew_SoThuLy(NgayThuLy);
            Cls_Comon.SetFocus(this, this.GetType(), txtSoThuLy.ClientID);
        }

        private void SetNew_SoThuLy()
        {
            //decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            //DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? date : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //decimal ToaID = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            //try
            //{
            //    AHS_KCKNQDK_PHUCTHAM_BL obj = new AHS_KCKNQDK_PHUCTHAM_BL();
            //    decimal STT = obj.GETNEWTT(ToaID, NgayThuLy);
            //    txtSoThuLy.Text = STT.ToString();
            //}
            //catch( Exception ex) { txtSoThuLy.Text = "1"; }
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            AHS_KCKNQDK_PHUCTHAM_BL oSTBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            if (String.IsNullOrEmpty(txtNgayThuLy.Text))
                txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");

            DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //Số thụ lý mới
            txtSoThuLy.Text = oSTBL.GET_STL_NEW_HS(DonViID, "AHS_PTQDK", CheckThanhNien(), ngaythuly).ToString();
        }

        private void LoadGrid()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL obj = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable tbl = obj.GetByVuAnID(VuAnID);
            rpt.DataSource = tbl;
            rpt.DataBind();
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT != null)
                {
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                    }
                }

                AHS_KCKNQDK_PHUCTHAM_HDXX qdBA = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {DONID}").FirstOrDefault();
                if (qdBA != null)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = lblSua.Visible = false;
                }

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!String.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ThuLyID = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    hddID.Value = ThuLyID + ""; ;
                    LoadInfo(ThuLyID);
                    break;

                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lstMsgB.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    AHS_KCKNQDK_PHUCTHAM_THULY oT = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_THULY>(ThuLyID);
                    //Luu thong tin Thụ lý Phúc thẩm trước khi xoa
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    var json = new JavaScriptSerializer().Serialize(oT);
                    ADS_DON_BL oBL = new ADS_DON_BL();
                    if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oT.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Thụ lý Phúc thẩm án Hình sự", "Xóa", json) == false)
                    {
                        lstMsgB.Text = "Xóa không thành công!";
                        return;
                    }//Ket thuc
                     //Xoa Thụ lý Phúc thẩm
                    DataExtensions.Delete(oT);
                    LoadGrid();
                    break;
            }
        }

        private void ResetForm()
        {
            txtTuNgay.Text = txtDenNgay.Text = "";
            //txtTuNgay.Text = txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

            hddID.Value = "0";
            ddTruongHopTL.SelectedIndex = 0;
            txtSoThuLy.Text = "";
            txtNgayThuLy.Text = "";
            ddlNguoiky.SelectedIndex = 0;
            //AHS_KCKNQDK_PHUCTHAM_THULY oT = new AHS_KCKNQDK_PHUCTHAM_THULY();
            //Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            //AHS_KCKNQDK_PHUCTHAM_BL dsBL = new AHS_KCKNQDK_PHUCTHAM_BL();

            //SetNew_SoThuLy(DateTime.Now);
            cbUTTP.Checked = false;
        }

        protected void cmdThemmoi_Click(object sender, EventArgs e)
        {
            ResetForm();
            CheckQuyen();
        }

        private bool CheckValidate()
        {
            if (ddTruongHopTL.SelectedValue == "")
            {
                lstMsgB.Text = "Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!";
                ddTruongHopTL.Focus();
                return false;
            }

            if (Cls_Comon.IsValidDate(txtNgayThuLy.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy)!";
                txtNgayThuLy.Focus();
                return false;
            }

            if (ddlNguoiky.SelectedValue == "")
            {
                lstMsgB.Text = "Bạn chưa chọn người ký. Hãy kiểm tra lại!";
                ddlNguoiky.Focus();
                return false;
            }
            if (!Regex.IsMatch(txtSoThuLy.Text, @"^\d"))
            {
                lstMsgB.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }
            //----------------------------
            string sothuly = txtSoThuLy.Text;
            if (!String.IsNullOrEmpty(txtNgayThuLy.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHS_KCKNQDK_PHUCTHAM_BL oSTBL = new AHS_KCKNQDK_PHUCTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHS_PTQDK", CheckThanhNien(), sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW_HS(DonViID, "AHS_PTQDK", CheckThanhNien(), ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số thụ lý " + txtSoThuLy.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuLy.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuLy.Focus();
                        return false;
                    }
                }
            }
            return true;
        }

        private decimal CheckThanhNien()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.ISTHANHNIEN == 0)
            {
                return 2;
            }
            else
            {
                AHS_BICANBICAO dtBiCao = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                AHS_NGUOITHAMGIATOTUNG dtTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                if (dtBiCao != null || dtTGTT != null)
                {
                    return 1;
                }
                return 0;
            }
        }
    }
}