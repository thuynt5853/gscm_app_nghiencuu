using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.THA;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
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
using BL.GSTP.AHS;
using BL.GSTP.Quantri;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.THA.CongVanTHA
{
    public partial class QuyetDinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0, VuAnID = 0, BiAnID = 0;
        public String NgaySoSanh = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                if (!IsPostBack)
                {
                    THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                    if (objBA != null)
                        VuAnID = (decimal)objBA.VUANID;
                    LoadDrop();
                    CheckQuyen();
                    Decimal ThuLyCV_ID = String.IsNullOrEmpty(Request["tID"] + "") ? 0 : Convert.ToDecimal(Request["tID"] + "");
                    if (ThuLyCV_ID == 0)
                    {
                        lstMsgTop.Text = "Bạn chưa thực hiện thụ lý công văn/đơn. Đề nghị thực hiện 'Thụ lý công văn/đơn' trước khi thực hiện việc này";
                        cmdUpdate.Visible = false;
                        return;
                    }
                    lkFile.Visible = cmdXoa.Visible = false;
                    hddCurrThuLyID.Value = ThuLyCV_ID.ToString();
                    if (ThuLyCV_ID > 0)
                        LoadInfo(ThuLyCV_ID);
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdate.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdUpdate.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }

            if (!string.IsNullOrEmpty(dropQuyetDinh_TB.SelectedValue))
            {
                decimal id = Convert.ToDecimal(dropQuyetDinh_TB.SelectedValue);
                //938: Quyết định hoãn thi hành hình phạt tù, 939: Quyết định tạm đình chỉ chấp hành phạt tù, 2638: Quyết định tha tù trước thời hạn có điều kiện
                if (id == 939 || id == 938 || id == 2638)
                {
                    try
                    {
                        THA_BIAN_BL objBL = new THA_BIAN_BL();
                        string result = objBL.CHECK_THA_BIAN_DONGBO(BiAnID, id);
                        if (!string.IsNullOrEmpty(result))
                        {
                            lttMsg.Text = lstMsgTop.Text = dropQuyetDinh_TB.Text + result;
                            cmdUpdate.Visible = cmdXoa.Visible = false;
                        }
                    }
                    catch (Exception ex) { }
                }
            }
        }

        void LoadDrop()
        {
            LoadDropByGroupName(dropQuyetDinh_TB, ENUM_DANHMUC.QUYETDINH_TB_THA, true);

            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);

            ddlNguoiki.DataSource = oCBDT;
            ddlNguoiki.DataTextField = "HOTEN";
            ddlNguoiki.DataValueField = "ID";
            ddlNguoiki.DataBind();
            ddlNguoiki.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("------- Chọn --------", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }
        protected void lkFile_Click(object sender, EventArgs e)
        {
            DowloadFile();
        }

        void DowloadFile()
        {
            try
            {
                Decimal CurrID = Convert.ToDecimal(hddCurrThuLyID.Value);
                THA_CVDON_QD oND = dt.THA_CVDON_QD.Where(x => x.CVDONID == CurrID).FirstOrDefault();
                if (oND.QT_FILE_ID != null)
                {
                    QT_FILE qtFileGet = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                    var cacheKey = Guid.NewGuid().ToString("N");
                    QT_FILE_BL fileH = new QT_FILE_BL();
                    byte[] file = fileH.GetNoiDungFile_Minio_THA(qtFileGet, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                    if (file == null)
                    {
                        lstMsgTop.Text = "Không tìm thấy file đính kèm!";
                        return;
                    }
                    string fileName = qtFileGet.FILE_NAME;
                    Context.Cache.Insert(key: cacheKey, value: file, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + qtFileGet.FILE_NAME + "&Extension=" + qtFileGet.FILE_TYPE + "';", true);
                }
            }
            catch (Exception ex)
            {
                lstMsgTop.Text = ex.Message;
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", ex.Message);
            }
        }


        protected void ddlNguoiki_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNguoiki.SelectedValue != "0")
            {
                try
                {
                    Decimal CanBoID = Convert.ToDecimal(ddlNguoiki.SelectedValue);
                    Decimal ChucVuID = (Decimal)dt.DM_CANBO.Where(x => x.ID == CanBoID).SingleOrDefault().CHUCVUID;

                    txtChucVu.Text = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).SingleOrDefault().TEN;
                }
                catch (Exception ex)
                {
                    //lstMsgTop.Text = ex.Message;
                }
            }
        }
        private void ResertControll()
        {
            txtSoQD.Text = txtNgayQD.Text = "";
            txtHieuLuc_TuNgay.Text = txtNgayHieuLuc_DenNgay.Text = "";

            ddlNguoiki.SelectedValue = "0";
            txtChucVu.Text = "";
            rdKetQua.SelectedValue = "0";
            txtGhiChu.Text = "";
        }
        protected void cmdResert_Click(object sender, EventArgs e)
        {
            ResertControll();
        }
        //--------------------------------------
        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("QuyetDinh_DS.aspx");
        }
        #region Update data
        private void GetDataToUpdate(THA_CVDON_QD obj)
        {
            Decimal ThuLyCV_ID = String.IsNullOrEmpty(hddCurrThuLyID.Value) ? 0 : Convert.ToDecimal(hddCurrThuLyID.Value);

            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            if (VuAnID == 0)
            {
                THA_BIAN oT = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                if (oT != null)
                    VuAnID = (decimal)oT.VUANID;
            }

            //--------------------------------           
            obj.BIANID = BiAnID;
            obj.VUANID = VuAnID;
            obj.CVDONID = ThuLyCV_ID;
            obj.QUYETDINHID = Convert.ToDecimal(dropQuyetDinh_TB.SelectedValue);

            //-------------------
            obj.SOQD = txtSoQD.Text;
            obj.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //----------Ngày quyết đinh/hiệu lực từ ngày/den ngay-------------
            obj.HIEULUC_TUNGAY = (String.IsNullOrEmpty(txtHieuLuc_TuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            obj.HIEULUC_DENNGAY = (String.IsNullOrEmpty(txtNgayHieuLuc_DenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHieuLuc_DenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //-----------------------------
            obj.NGUOIKY = ddlNguoiki.SelectedValue + "";
            obj.CHUCVU = txtChucVu.Text.Trim();

            obj.KETQUA = Convert.ToDecimal(rdKetQua.SelectedValue);
            obj.GHICHU = txtGhiChu.Text;
            UploadFile(obj);
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath",
                    "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            Decimal ThuLyCV_ID = String.IsNullOrEmpty(hddCurrThuLyID.Value) ? 0 : Convert.ToDecimal(hddCurrThuLyID.Value);

            if (ThuLyCV_ID == 0)
            {
                lstMsgTop.Text = "Bạn chưa thực hiện thụ lý công văn/đơn. Đề nghị thực hiện 'Thụ lý công văn/đơn' trước khi thực hiện việc này";
                cmdUpdate.Visible = false;
                return;
            }

            THA_CVDON_QD obj = dt.THA_CVDON_QD.Where(x => x.BIANID == BiAnID
                                                       && x.CVDONID == ThuLyCV_ID).FirstOrDefault();
            if (obj != null)
            {
                GetDataToUpdate(obj);
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            else
            {
                obj = new THA_CVDON_QD();
                GetDataToUpdate(obj);
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_CVDON_QD.Add(obj);
            }
            lkFile.Visible = cmdXoa.Visible = obj.QT_FILE_ID != null;
            dt.SaveChanges();
            lstMsgTop.Text = "Lưu thành công!";
        }

        #endregion

        /*        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
                {
                    if (!String.IsNullOrEmpty(txtNgayQD.Text))
                    {
                        txtHieuLuc_TuNgay.Text = txtNgayQD.Text;
                        DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        //-------------------
                        int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
                        int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
                        DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
                        txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
                        //-------------------
                        int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
                        int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
                        DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
                        txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
                    }
                }*/

        //--------------------------------------

        void UploadFile(THA_CVDON_QD obj)
        {
            if (hddFilePath.Value != "")
            {
                string strFilePath = hddFilePath.Value.Replace("/", "\\");
                QT_FILE_BL fileHelper = new QT_FILE_BL();
                QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                if (qtFile == null)
                {
                    lstMsgTop.Text = "Lỗi khi lưu file!";
                    return;
                }

                // Cập nhật QT_FILE_ID trực tiếp trên entity được track
                obj.QT_FILE_ID = qtFile.ID;
                lkFile.Text = qtFile.FILE_NAME;

                /*                    File.Delete(strFilePath);*/
            }
        }
        void LoadInfo(Decimal ThuLyCV_ID)
        {
            THA_CVDON_THULY objThuLy = dt.THA_CVDON_THULY.Where(x => x.ID == ThuLyCV_ID).Single<THA_CVDON_THULY>();
            if (objThuLy != null)
            {
                Decimal YeuCauID = (Decimal)objThuLy.YEUCAUID;
                Decimal LyDoId = (Decimal)objThuLy.LYDOID;
                hddLoadID.Value = objThuLy.BIANID.ToString();
                try
                {
                    DM_DATAITEM objItem = dt.DM_DATAITEM.Where(x => x.ID == YeuCauID).Single<DM_DATAITEM>();
                    txtYeuCau.Text = objItem.TEN;

                    objItem = dt.DM_DATAITEM.Where(x => x.ID == LyDoId).Single<DM_DATAITEM>();
                    txtLyDo.Text = objItem.TEN;
                    //objItem.
                }
                catch (Exception ex) { }
            }
            //----------------------
            THA_CVDON_QD obj = dt.THA_CVDON_QD.Where(x => x.CVDONID == ThuLyCV_ID && x.BIANID == BiAnID).SingleOrDefault<THA_CVDON_QD>();
            if (obj != null)
            {
                txtSoQD.Text = obj.SOQD;
                txtNgayQD.Text = (((DateTime)obj.NGAYQD) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul);
                dropQuyetDinh_TB.SelectedValue = obj.QUYETDINHID.ToString();
                dropQuyetDinh_TB.Enabled = false;
                //-------------------------------------
                txtHieuLuc_TuNgay.Text = (((DateTime)obj.HIEULUC_TUNGAY) == DateTime.MinValue) ? "" : ((DateTime)obj.HIEULUC_TUNGAY).ToString("dd/MM/yyyy", cul);
                txtNgayHieuLuc_DenNgay.Text = (((DateTime)obj.HIEULUC_DENNGAY) == DateTime.MinValue) ? "" : ((DateTime)obj.HIEULUC_DENNGAY).ToString("dd/MM/yyyy", cul);

                //-------------------------------------
                rdKetQua.SelectedValue = obj.KETQUA.ToString();

                try { ddlNguoiki.SelectedValue = obj.NGUOIKY.ToString(); } catch (Exception ex) { }
                txtChucVu.Text = obj.CHUCVU;
                txtGhiChu.Text = obj.GHICHU;
                if (obj.QT_FILE_ID != null)
                {
                    QT_FILE qtFile = DataExtensions.FindById<QT_FILE>(obj.QT_FILE_ID.Value);
                    lkFile.Text = hddFilePath.Value = qtFile.FILE_NAME;
                    lkFile.Visible = cmdXoa.Visible = obj.QT_FILE_ID != null;
                }
            }
        }

        protected void cmdXoa_Click(object sender, ImageClickEventArgs e)
        {
            Decimal CurrID = Convert.ToDecimal(hddLoadID.Value);
            THA_CVDON_QD oND = dt.THA_CVDON_QD.Where(x => x.BIANID == CurrID).FirstOrDefault();
            if (oND.QT_FILE_ID != null)
            {
                QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                if (qtFileDelete != null)
                {
                    qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                    QT_FILE_BL fileH = new QT_FILE_BL();
                    fileH.DeleteFileLogic(qtFileDelete);
                }
                oND.QT_FILE_ID = null;
                dt.SaveChanges();
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Tệp đính kèm được xóa thành công!");
            }

            hddFilePath.Value = "";
            cmdXoa.Visible = false;
            lkFile.Visible = false;
        }

        protected void dropQuyetDinh_TB_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(dropQuyetDinh_TB.SelectedValue))
            {
                decimal id = Convert.ToDecimal(dropQuyetDinh_TB.SelectedValue);
                //938: Quyết định hoãn thi hành hình phạt tù, 939: Quyết định tạm đình chỉ chấp hành phạt tù, 2638: Quyết định tha tù trước thời hạn có điều kiện
                if (id == 939 || id == 938 || id == 2638)
                {
                    try
                    {
                        THA_BIAN_BL objBL = new THA_BIAN_BL();
                        string result = objBL.CHECK_THA_BIAN_DONGBO(BiAnID, id);
                        if (!string.IsNullOrEmpty(result))
                        {
                            lttMsg.Text = lstMsgTop.Text = dropQuyetDinh_TB.Text + result;
                            cmdUpdate.Visible = cmdXoa.Visible = false;
                        }
                    }
                    catch (Exception ex) { }
                }
            }
        }
    }
}