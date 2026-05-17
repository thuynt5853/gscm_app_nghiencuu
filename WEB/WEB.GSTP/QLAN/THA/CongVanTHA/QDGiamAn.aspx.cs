using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP.THA;
using BL.GSTP.Quantri;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.THA.CongVanTHA
{
    public partial class QDGiamAn : System.Web.UI.Page
    {
        decimal VuAnID = 0, BiAnID = 0;
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        THA_CVDON_GIAMAN obj = new THA_CVDON_GIAMAN();
        private const decimal ROOT = 0;
        public string NgaySoSanh;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                if (BiAnID > 0)
                {
                    pn.Visible = true;
                    CheckQuyen();
                    Load_BiAn();
                    loadDropNguoiKi();
                    LoadDropTinh();
                    LoadDropHuyentheoTinh();
                    LoadGrid();
                    txtNgayRaQD.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    pn.Visible = false;
                    lbThongbao_top.Text = "Bạn cần chọn bị án để xử lý!";
                }
            }
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_CVDON_KQGQ obj = dt.THA_CVDON_KQGQ.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_CVDON_KQGQ>();
                if (obj == null)
                {
                    lttMsg.Text = "Bị án chưa có kết quả giải quyết. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có kết quả giải quyết. Bạn hãy kiểm tra lại!";
                cmdUpdate.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            try
            {
                THA_CVDON_QD obj = dt.THA_CVDON_QD.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_CVDON_QD>();
                if (obj == null)
                {
                    lttMsg.Text = "Bị án chưa có quyết định. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có quyết định. Bạn hãy kiểm tra lại!";
                cmdUpdate.Visible = false;
                IsOk = false;
            }
        }

        void Load_BiAn()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (obj != null)
            {
                VuAnID = (decimal)obj.VUANID;
            }
        }

        private void loadEdit(decimal ID)
        {
            THA_CVDON_GIAMAN oGA = dt.THA_CVDON_GIAMAN.Where(x => x.ID == ID).FirstOrDefault();
            if (oGA != null)
            {
                HddID.Value = ID.ToString();
              
                txtSoQuyetDinh.Text = oGA.SOQD;
                txtNgayRaQD.Text = string.IsNullOrEmpty(oGA.NGAYQD + "") ? "" : ((DateTime)oGA.NGAYQD).ToString("dd/MM/yyyy", cul);

                txtNam.Text = oGA.GIAM_NAM == 0 ? "" : oGA.GIAM_NAM + "";
                txtThang.Text = oGA.GIAM_THANG == 0 ? "" : oGA.GIAM_THANG + "";
                txtngay.Text = oGA.GIAM_NGAY == 0 ? "" : oGA.GIAM_NGAY + "";

                DropTinh.SelectedValue = oGA.CHHP_TINH.ToString();
                LoadDropHuyentheoTinh();
                DropQuan_huyen.SelectedValue = oGA.CHHP_HUYEN.ToString();
                txtDiaChiCT.Text = oGA.CHHP_CHITIET;

                try
                {
                    DropNguoiKi.SelectedValue = oGA.NGUOIKYID + "";
                    Decimal chucvu_id = (Decimal)oGA.CHUCVUID;
                    txtChucVu.Text = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).SingleOrDefault().TEN;
                }
                catch (Exception ex) { }
            }
        }

        //-----------------------------------------
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            decimal BiAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_CVDON_GIAMAN_BL objBL = new THA_CVDON_GIAMAN_BL();
            DataTable tbl = objBL.GetAllByBiAn(BiAnID);
            if (tbl != null)
            {
                dgList.DataSource = tbl;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
                pndata.Visible = false;
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
                        lbthongbao.Text = "";
                        loadEdit(ID);
                        HddID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        xoa(ID);
                        break;
                    case "Download":
                        try
                        {
                            THA_CVDON_GIAMAN giamAn = dt.THA_CVDON_GIAMAN.Where(x => x.ID == ID).FirstOrDefault();
                            if (giamAn.QT_FILE_ID != null)
                            {
                                QT_FILE qtFileGet = DataExtensions.FindById<QT_FILE>(giamAn.QT_FILE_ID.Value);
                                var cacheKey = Guid.NewGuid().ToString("N");
                                QT_FILE_BL fileH = new QT_FILE_BL();
                                byte[] file = fileH.GetNoiDungFile_Minio_THA(qtFileGet, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                                if (file == null)
                                {
                                    lbthongbao.Text = "Không tìm thấy file đính kèm!";
                                    return;
                                }
                                Context.Cache.Insert(key: cacheKey, value: file, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + qtFileGet.FILE_NAME + "&Extension=" + qtFileGet.FILE_TYPE + "';", true);
                            }
                        }
                        catch (Exception ex)
                        {
                            lbthongbao.Text = ex.Message;
                            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", ex.Message);
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");

                DataRowView rowView = (DataRowView)e.Item.DataItem;
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");

                lblDownload.Visible = !string.IsNullOrEmpty(rowView["FILE_ID"] + "");
                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"] + "";
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lbtSua.Visible = false;
                }
            }
        }


        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile)
                {
                    string strFileName = AsyncFileUpLoad.FileName;
                    string path = Server.MapPath("~/TempUpload/") + strFileName;
                    AsyncFileUpLoad.SaveAs(path);
                    path = path.Replace("\\", "/");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        public void xoa(decimal ID)
        {
            THA_CVDON_GIAMAN oGA = dt.THA_CVDON_GIAMAN.Where(x => x.ID == ID).FirstOrDefault();
            if (oGA != null)
            {

                // xoa file MinIO
                if (oGA.QT_FILE_ID != null)
                {
                    QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oGA.QT_FILE_ID.Value);
                    if (qtFileDelete != null)
                    {
                        qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                        QT_FILE_BL fileH = new QT_FILE_BL();
                        fileH.DeleteFileLogic(qtFileDelete);
                        hddFilePath.Value = "";
                    }
                }
                dt.THA_CVDON_GIAMAN.Remove(oGA);
                dt.SaveChanges();
                LoadGrid();
                ResetControls();
                dgList.CurrentPageIndex = 0;
                lbthongbao.Text = "Xóa thành công!";
            }
        }

        //-----------------------------------------
        protected void cmdResert_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void ResetControls()
        {
            txtSoQuyetDinh.Text = "";
            txtDiaChiCT.Text = "";
            txtChucVu.Text = "";
            txtNam.Text = "";
            txtngay.Text = "";
            txtThang.Text = "";
            txtNgayRaQD.Text = "";

            DropTinh.SelectedIndex = 0;
            DropNguoiKi.SelectedIndex = 0;
            DropQuan_huyen.SelectedIndex = 0;

            HddID.Value = "0";
            lbthongbao.Text = "";
        }

        //--------------------------------------
        public void loadDropNguoiKi()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);

            DropNguoiKi.DataSource = oCBDT;
            DropNguoiKi.DataTextField = "HOTEN";
            DropNguoiKi.DataValueField = "ID";
            DropNguoiKi.DataBind();
            DropNguoiKi.Items.Insert(0, new ListItem("--Chọn--", "0"));

        }

        protected void DropNguoiKi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropNguoiKi.SelectedValue != "0")
            {
                try
                {
                    Decimal CanBoID = Convert.ToDecimal(DropNguoiKi.SelectedValue);
                    Decimal ChucVuID = (Decimal)dt.DM_CANBO.Where(x => x.ID == CanBoID).SingleOrDefault().CHUCVUID;
                    hddChucVuID.Value = ChucVuID.ToString();

                    txtChucVu.Text = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).SingleOrDefault().TEN;
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = ex.Message;
                }
            }
        }

        //--------------------------------------
        private void LoadDropTinh()
        {
            DropTinh.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                DropTinh.DataSource = lstTinh;
                DropTinh.DataTextField = "TEN";
                DropTinh.DataValueField = "ID";
                DropTinh.DataBind();
                DropTinh.Items.Insert(0, new ListItem("--Chọn--", "0"));
            }
            else
                DropTinh.Items.Add(new ListItem("--Chọn--", "0"));
            LoadDropHuyentheoTinh();
        }

        private void LoadDropHuyentheoTinh()
        {
            DropQuan_huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(DropTinh.SelectedValue);
            if (TinhID > 0)
            {
                List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                if (lstHuyen != null && lstHuyen.Count > 0)
                {
                    DropQuan_huyen.DataSource = lstHuyen;
                    DropQuan_huyen.DataTextField = "TEN";
                    DropQuan_huyen.DataValueField = "ID";
                    DropQuan_huyen.DataBind();
                    DropQuan_huyen.Items.Insert(0, new ListItem("--Chọn--", "0"));
                }
                else
                    DropQuan_huyen.Items.Add(new ListItem("--Chọn--", "0"));
            }
            else
                DropQuan_huyen.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }

        protected void DropTinh_SelectedIndexChanged(object sender, EventArgs e)
        {

            try
            {
                if (DropTinh.SelectedValue != "0")
                    LoadDropHuyentheoTinh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }

        }

        void UploadFile(THA_CVDON_GIAMAN obj)
        {
            if (hddFilePath.Value != "")
            {
                string strFilePath = hddFilePath.Value.Replace("/", "\\");
                QT_FILE_BL fileHelper = new QT_FILE_BL();
                QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                if (qtFile == null)
                {
                    lbthongbao.Text = "Lỗi khi lưu file!";
                    return;
                }

                // Cập nhật QT_FILE_ID trực tiếp trên entity được track
                obj.QT_FILE_ID = qtFile.ID;
            }
        }

        //--------------------------------------
        public void LayDuLieuUpdate(THA_CVDON_GIAMAN obj)
        {
            Load_BiAn();
            //chua save chuc vu
            obj.NGUOIKYID = String.IsNullOrEmpty(DropNguoiKi.SelectedValue) ? 0 : Convert.ToDecimal(DropNguoiKi.SelectedValue);
            obj.CHUCVUID = String.IsNullOrEmpty(hddChucVuID.Value + "") ? 0 : Convert.ToDecimal(hddChucVuID.Value);
            //-----------------
            //load ID theo vụ an dc giam            
            obj.BIANID = BiAnID;
            obj.VUANID = VuAnID;
            //------------------
            //chi tiết viề địa chỉ.            
            obj.CHHP_TINH = Convert.ToDecimal(DropTinh.SelectedValue);
            obj.CHHP_HUYEN = Convert.ToDecimal(DropQuan_huyen.SelectedValue);
            obj.CHHP_CHITIET = txtDiaChiCT.Text.Trim();
            //------------------
            //thoi gian duoc giam.
            obj.GIAM_NAM = String.IsNullOrEmpty(txtNam.Text.Trim()) ? 0 : Convert.ToDecimal(txtNam.Text);
            obj.GIAM_THANG = String.IsNullOrEmpty(txtThang.Text.Trim()) ? 0 : Convert.ToDecimal(txtThang.Text);
            obj.GIAM_NGAY = String.IsNullOrEmpty(txtngay.Text.Trim()) ? 0 : Convert.ToDecimal(txtngay.Text);
            //------------------
            // số QD+ngày QD.
            obj.NGAYQD = (String.IsNullOrEmpty(txtNgayRaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayRaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.SOQD = txtSoQuyetDinh.Text.Trim();
            UploadFile(obj);
            //-------------------
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                THA_CVDON_GIAMAN obj = dt.THA_CVDON_GIAMAN.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                if (obj != null)
                {
                    LayDuLieuUpdate(obj);
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                else
                {
                    obj = new THA_CVDON_GIAMAN();
                    LayDuLieuUpdate(obj);
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.THA_CVDON_GIAMAN.Add(obj);
                  
                }
                dt.SaveChanges();
                LoadGrid();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception exc)
            {
                lbthongbao.Text = exc.Message;
            }

        }
    }
}