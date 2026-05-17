using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.HOAGIAI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.HOAGIAI
{
    public partial class DeNghiKienNghi : System.Web.UI.Page
    {
        private QT_FILE_BL fileHelper = new QT_FILE_BL();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal loaiAn = 0;
        public Decimal vuViecId = 0;
        private GSTPContext dt = new GSTPContext();
        private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
        private bool isUpdateAction = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            lblThongBao.Text = "";
            string strMaCT = Session["MaChuongTrinh"] + "";
            string returnURL = "";
            switch (strMaCT)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU].ToString());
                    break;

                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH].ToString());
                    break;

                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI].ToString());
                    break;

                case ENUM_LOAIAN.AN_LAODONG:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG].ToString());
                    break;

                case ENUM_LOAIAN.AN_HANHCHINH:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH].ToString());
                    break;

                default:
                    returnURL = "/Trangchu.aspx";
                    break;
            }
            if (vuViecId == 0) Response.Redirect(returnURL);
            hddLoaiAn.Value = loaiAn.ToString();
            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();
            if (hoaGiaiDon == null)
                Response.Redirect(returnURL);
            if (!IsPostBack)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);
                rdbLoai_SelectedIndexChanged(new object(), new EventArgs());
                this.isUpdateAction = this.checkQuyen();
                this.InitData();
                this.LoadGrid();
            }
        }

        public bool checkQuyen()
        {
            var checkThuLy = _hoaGiaiBl.CheckThuLy(this.vuViecId, this.loaiAn);
            if (checkThuLy)
            {
                Cls_Comon.SetButton(btnUpdate, true);
            }
            else
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được thụ lý. Không được sửa!";
                return false;
            }
            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {this.vuViecId} AND LOAIANID = {this.loaiAn}").FirstOrDefault();
            var quyetDinh = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {hoaGiaiDon.ID} AND KETQUAID = {(int)ENUM_CONGNHAN_HOAGIAI.CONGNHAN}").FirstOrDefault();
            if (quyetDinh == null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc chưa có quyết định công nhận hòa giải thành.";
                return false;
            }

            var kqDNKN = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
            if (kqDNKN != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã có kết quả giải quyết đề nghị/kiến nghị. Không được sửa đổi";
                return false;
            }
            return true;
        }

        private void InitData()
        {
            this.InitNguoiDeNghiTuCach();
            this.InitQuyetDinh();
        }

        private void InitNguoiDeNghiTuCach()
        {
            if (this.vuViecId == 0 || this.loaiAn == 0)
                return;
            List<ListItem> lstDdlNguoiDeNghi = new List<ListItem>() { };
            List<ListItem> lstTuCachDuongSu = new List<ListItem>() { };
            HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
            var tbl = hoaGiaiBL.GetDuongSu(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn);
            lstDdlNguoiDeNghi.Clear();
            lstTuCachDuongSu.Clear();
            foreach (DataRow row in tbl.Rows)
            {
                lstDdlNguoiDeNghi.Add(new ListItem(row["TENDUONGSU"].ToString() + " - " + row["TENTCTT"].ToString(), row["ID"].ToString()));
                lstTuCachDuongSu.Add(new ListItem(row["TENTCTT"].ToString(), row["ID"].ToString()));
            }
            ddlTuCachDuongSu.Enabled = false;
            ddlNguoiDeNghi.Items.AddRange(lstDdlNguoiDeNghi.ToArray());
            ddlTuCachDuongSu.Items.AddRange(lstTuCachDuongSu.ToArray());
        }

        private void InitQuyetDinh()
        {
            if (this.vuViecId == 0 || this.loaiAn == 0)
                return;
            List<HOAGIAI_QUYETDINH> lstQuyetDinh = new List<HOAGIAI_QUYETDINH>() { };
            HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
            lstQuyetDinh = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {hg.ID} AND KETQUAID = {(int)ENUM_CONGNHAN_HOAGIAI.CONGNHAN}").ToList();
            if (lstQuyetDinh.Count == 0)
            {
                ddlQuyetDinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                ddlKNQuyetDinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                ddlQuyetDinh.Items.AddRange(
                    lstQuyetDinh
                    .ConvertAll<ListItem>(i =>
                    new ListItem("Số: " + i.SOQUYETDINH + " - Ngày: " + i.NGAYQUYETDINH?.ToVNDate(), i.ID.ToString())).ToArray()
                    );
                ddlKNQuyetDinh.Items.AddRange(
                    lstQuyetDinh
                    .ConvertAll<ListItem>(i =>
                    new ListItem("Số: " + i.SOQUYETDINH + " - Ngày: " + i.NGAYQUYETDINH?.ToVNDate(), i.ID.ToString())).ToArray()
                    );
                this.ddlQuyetDinh_SelectedIndexChanged(null, null);
                this.ddlKNQuyetDinh_SelectedIndexChanged(null, null);
            }
            //Tòa ra quyết định

            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            var toaRaQD = oBL.DM_TOAAN_GETBY(Convert.ToDecimal(hg.TOAANID.ToString()));

            ddlToaAnRaQD.DataSource = toaRaQD;
            ddlToaAnRaQD.DataTextField = "arrTEN";
            ddlToaAnRaQD.DataValueField = "ID";
            ddlToaAnRaQD.DataBind();

            ddlKNToaAnRaQĐ.DataSource = toaRaQD;
            ddlKNToaAnRaQĐ.DataTextField = "arrTEN";
            ddlKNToaAnRaQĐ.DataValueField = "ID";
            ddlKNToaAnRaQĐ.DataBind();

            #region Init đơn vị kháng nghị

            List<DM_VKS> lstVKS = DataExtensions.GetAllWithClause<DM_VKS>($"TOAANID={hg.TOAANID}").ToList();
            ddlDonViKN.DataSource = lstVKS;
            ddlDonViKN.DataTextField = "TEN";
            ddlDonViKN.DataValueField = "ID";
            ddlDonViKN.DataBind();

            #endregion Init đơn vị kháng nghị
        }

        protected void ddlNguoiDeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal Id = Convert.ToDecimal(ddlNguoiDeNghi.SelectedValue);
                ddlTuCachDuongSu.SelectedValue = Id.ToString();
            }
            catch
            {
            }
        }

        protected void ddlQuyetDinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal Id = Convert.ToDecimal(ddlQuyetDinh.SelectedValue);
                HOAGIAI_QUYETDINH quyetDinh = DataExtensions.FindById<HOAGIAI_QUYETDINH>(Id);
                if (quyetDinh != null)
                {
                    txtNgayQĐ.Text = quyetDinh.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
                }
            }
            catch
            {
            }
        }

        protected void ddlKNQuyetDinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal Id = Convert.ToDecimal(ddlKNQuyetDinh.SelectedValue);
                HOAGIAI_QUYETDINH quyetDinh = DataExtensions.FindById<HOAGIAI_QUYETDINH>(Id);
                if (quyetDinh != null)
                {
                    txtKNNgayQuyetDinh.Text = quyetDinh.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
                }
            }
            catch
            {
            }
        }

        public void LoadGrid()
        {
            if (this.vuViecId == 0 || this.loaiAn == 0)
                return;
            HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
            var tbl = hoaGiaiBL.GetAllDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 0);
            dgList.CurrentPageIndex = 0;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        public void LoadEdit(decimal id)
        {
            HOAGIAI_DENGHI_KIENNGHI dnKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI>(id);
            if (dnKN != null)
            {
                this.btnLammoi_Click(null, null);
                txtKienNghiID.Text = dnKN.ID.ToString();
                rdbLoai.SelectedValue = dnKN.LOAIID.ToString();
                rdbLoai_SelectedIndexChanged(null, null);
                if (dnKN.LOAIID == 1)
                {
                    //Đề nghị
                    rdbHinhThucNhanDon.SelectedValue = dnKN.HINHTHUCNHANDON.ToString();
                    txtNgayDeNghi.Text = dnKN.NGAYDENGHI?.ToVNDate().Replace("-", "/");
                    txtNgayTrenDon.Text = dnKN.NGAYVIETDON?.ToVNDate().Replace("-", "/");
                    ddlNguoiDeNghi.SelectedValue = dnKN.NGUOIDENGHIID.ToString();
                    txtNoiDungDeNghi.Text = dnKN.NOIDUNG;
                    ddlNguoiDeNghi.SelectedValue = dnKN.NGUOIDENGHIID.ToString();

                    HOAGIAI_QUYETDINH qUYETDINH = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {dnKN.HOAGIAIID} AND SOQUYETDINH='{dnKN.SOQUYETDINH}' ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
                    if (qUYETDINH == null)
                    {
                        lblThongBao.Text = "Không thể tìm thấy quyết định đã chọn";
                        ddlQuyetDinh.SelectedIndex = 0;
                    }
                    else
                    {
                        ddlQuyetDinh.SelectedValue = qUYETDINH.ID.ToString();
                    }

                    this.ddlNguoiDeNghi_SelectedIndexChanged(null, null);
                    this.ddlQuyetDinh_SelectedIndexChanged(null, null);
                    this.ddlNguoiDeNghi_SelectedIndexChanged(null, null);
                    if ((dnKN.FILEID + "") != "" && (dnKN.FILEID + "") != "0")
                    {
                        HOAGIAI_FILE hgFile = DataExtensions.FindById<HOAGIAI_FILE>(dnKN.FILEID.Value);
                        if (hgFile != null)
                        {
                            lbtDownloadDN.Text = hgFile.TENFILE + hgFile.DUOIFILE;
                            lbtDownloadDN.Visible = true;
                            hddFileid.Value = hgFile.FILESERVER_ID + "";
                        }
                    }
                    else
                    {
                        lbtDownloadDN.Text = "Tải file đính kèm";
                        lbtDownloadDN.Visible = false;
                    }
                }
                else
                {
                    txtSoKN.Text = dnKN.SOKIENNGHI;
                    txtNgayKN.Text = dnKN.NGAYKIENNGHI?.ToVNDate().Replace("-", "/");
                    HOAGIAI_QUYETDINH qUYETDINH = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {dnKN.HOAGIAIID} AND SOQUYETDINH='{dnKN.SOQUYETDINH}' ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
                    if (qUYETDINH == null)
                    {
                        lblThongBao.Text = "Không thể tìm thấy quyết định đã chọn";
                        ddlKNQuyetDinh.SelectedIndex = 0;
                    }
                    else
                    {
                        ddlKNQuyetDinh.SelectedValue = qUYETDINH.ID.ToString();
                    }
                    this.ddlKNQuyetDinh_SelectedIndexChanged(null, null);
                    if ((dnKN.FILEID + "") != "" && (dnKN.FILEID + "") != "0")
                    {
                        HOAGIAI_FILE hgFile = DataExtensions.FindById<HOAGIAI_FILE>(dnKN.FILEID.Value);
                        if (hgFile != null)
                        {
                            lbtDownloadKN.Text = hgFile.TENFILE + hgFile.DUOIFILE;
                            lbtDownloadKN.Visible = true;
                            hddFileid.Value = hgFile.FILESERVER_ID + "";
                        }
                    }
                    else
                    {
                        lbtDownloadKN.Text = "Tải file đính kèm";
                        lbtDownloadKN.Visible = false;
                    }
                }


            }

        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal APID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Download":
                        decimal FileID = Convert.ToDecimal(APID);
                        QT_FILE fileSR = DataExtensions.FindById<QT_FILE>(FileID);
                        if (fileSR != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            var NOIDUNG = fileHelper.GetNoiDungFile(fileSR, Convert.ToInt32(hddLoaiAn.Value));
                            Context.Cache.Insert(key: cacheKey, value: NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileSR.FILE_NAME + "&Extension=" + fileSR.FILE_TYPE + "';", true);
                        }
                        break;

                    case "Sua":
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(btnUpdate, false);
                        }
                        LoadEdit(APID);
                        break;

                    case "Xoa":
                        try
                        {
                            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                            if (oPer.XOA == false || btnUpdate.Enabled == false)
                            {
                                lblThongBao.Text = "Bạn không có quyền xóa!";
                                return;
                            }
                            HOAGIAI_DENGHI_KIENNGHI deNghiKienNghi = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI>(APID);
                            if (deNghiKienNghi == null)
                            {
                                lblThongBao.Text = "Không tồn đề nghị kiến nghị";
                                return;
                            }
                            bool result = DataExtensions.Delete<HOAGIAI_DENGHI_KIENNGHI>(new HOAGIAI_DENGHI_KIENNGHI() { ID = APID });
                            if (deNghiKienNghi.FILEID != null)
                            {
                                HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)deNghiKienNghi.FILEID);
                                QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
                                QT_FILE_BL file_BL = new QT_FILE_BL();
                                file_BL.DeleteFileLogic(qT_FILE);
                            }
                            if (result)
                            {
                                lblThongBao.Text = "Xóa thành công!";
                                this.LoadGrid();
                            }
                            else
                            {
                                lblThongBao.Text = "Không thể xóa hãy thử lại";
                            }
                        }
                        catch (Exception ex)
                        {
                            lblThongBao.Text = ex.Message;
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = ex.Message;
            }
        }

        protected void dgList_ItemDataBound(object source, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                var isExistsFile = String.IsNullOrEmpty(row["FILESID"].ToString());
                if (isExistsFile)
                {
                    var button = (ImageButton)e.Item.FindControl("lblDownload");
                    //var lable = (System.Web.UI.WebControls.Label)e.Item.FindControl("lblKhongCoFile");
                    button.Visible = !isExistsFile;
                    //lable.Visible = isExistsFile;
                }
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                if (this.isUpdateAction)
                {
                    lblSua.Text = "Sửa";
                }
                else
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (this.checkQuyen() == false)
                    return;
                string idKNStr = txtKienNghiID.Text;
                decimal idKN = 0;
                if (!String.IsNullOrEmpty(idKNStr))
                {
                    idKN = Convert.ToDecimal(idKNStr);
                }
                HOAGIAI_DENGHI_KIENNGHI deNghiKienNghi = new HOAGIAI_DENGHI_KIENNGHI();
                if (idKN != 0)
                {
                    deNghiKienNghi = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI>(idKN);
                    if (deNghiKienNghi == null)
                    {
                        lblThongBao.Text = "Dữ liệu không đúng";
                        throw new Exception("Dữ liệu không đúng");
                    }
                }
                string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                deNghiKienNghi.LOAIID = Convert.ToDecimal(rdbLoai.SelectedValue.ToString());
                HOAGIAI_QUYETDINH quyetDinh = null;
                if (deNghiKienNghi.LOAIID == 1)
                {
                    #region đề nghị

                    deNghiKienNghi.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayTrenDon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayTrenDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    deNghiKienNghi.NGAYDENGHI = (String.IsNullOrEmpty(txtNgayDeNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayDeNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    deNghiKienNghi.NGUOIDENGHIID = Convert.ToDecimal(ddlNguoiDeNghi.SelectedValue.ToString());
                    deNghiKienNghi.NOIDUNG = txtNoiDungDeNghi.Text;
                    deNghiKienNghi.HINHTHUCNHANDON = Convert.ToDecimal(rdbHinhThucNhanDon.SelectedValue);

                    #region GET Quyết định

                    quyetDinh = DataExtensions.FindById<HOAGIAI_QUYETDINH>(Convert.ToDecimal(ddlQuyetDinh.SelectedValue.ToString()));

                    #endregion GET Quyết định

                    #endregion đề nghị

                    #region Ghi đè kiến nghị = null

                    deNghiKienNghi.NGUOIKIENNGHIID = null;
                    deNghiKienNghi.DONVIKIENNGHIID = null;
                    deNghiKienNghi.SOKIENNGHI = null;
                    deNghiKienNghi.NGAYKIENNGHI = null;

                    #endregion Ghi đè kiến nghị = null
                }
                else
                {
                    #region Kiến nghị

                    deNghiKienNghi.NGUOIKIENNGHIID = Convert.ToDecimal(rdbKNDonVi.SelectedValue);
                    //deNghiKienNghi.
                    deNghiKienNghi.DONVIKIENNGHIID = Convert.ToDecimal(ddlDonViKN.SelectedValue);
                    deNghiKienNghi.SOKIENNGHI = txtSoKN.Text;
                    deNghiKienNghi.NGAYKIENNGHI = (String.IsNullOrEmpty(txtNgayKN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayKN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    #region GET Quyết định

                    quyetDinh = DataExtensions.FindById<HOAGIAI_QUYETDINH>(Convert.ToDecimal(ddlKNQuyetDinh.SelectedValue.ToString()));

                    #endregion GET Quyết định

                    #endregion Kiến nghị

                    #region Ghi đè đề nghị  = null

                    deNghiKienNghi.NGAYVIETDON = null;
                    deNghiKienNghi.NGAYDENGHI = null;
                    deNghiKienNghi.NGUOIDENGHIID = null;
                    deNghiKienNghi.NOIDUNG = null;
                    deNghiKienNghi.HINHTHUCNHANDON = null;

                    #endregion Ghi đè đề nghị  = null
                }
                if (quyetDinh == null)
                {
                    lblThongBao.Text = "Bạn chưa chọn Quyết Định";
                    throw new Exception("Bạn chưa chọn Quyết Định");
                }
                deNghiKienNghi.SOQUYETDINH = quyetDinh.SOQUYETDINH;
                deNghiKienNghi.NGAYQUYETDINH = quyetDinh.NGAYQUYETDINH;

                #region Hòa giải ID và Tòa ra quyết định

                HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
                deNghiKienNghi.HOAGIAIID = hg.ID;
                deNghiKienNghi.TOAANRAQUYETDINH = hg.TOAANID;

                #endregion Hòa giải ID và Tòa ra quyết định

                this.CheckValid(deNghiKienNghi);
                if (deNghiKienNghi.LOAIID == 1)
                {
                    if (hddFilePath.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath.Value.Replace("/", "\\");
                            QT_FILE itemFile = fileHelper.InsertFile(strFilePath, Convert.ToInt32(hddLoaiAn.Value));
                            HOAGIAI_FILE hgFile = new HOAGIAI_FILE()
                            {
                                DUOIFILE = itemFile.FILE_TYPE,
                                FILESERVER_ID = itemFile.ID,
                                KICHTHUOC = itemFile.FILE_SIZE,
                                TENFILE = itemFile.FILE_NAME
                            };
                            DataExtensions.Insert(hgFile);
                            deNghiKienNghi.FILEID = hgFile.ID;
                            File.Delete(strFilePath);
                            hddFilePath.Value = "";
                        }
                        catch (Exception ex) { lblThongBao.Text = ex.Message; }
                    }
                }
                else
                {
                    if (hddFilePathKN.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePathKN.Value.Replace("/", "\\");
                            QT_FILE itemFile = fileHelper.InsertFile(strFilePath, Convert.ToInt32(hddLoaiAn.Value));
                            HOAGIAI_FILE hgFile = new HOAGIAI_FILE()
                            {
                                DUOIFILE = itemFile.FILE_TYPE,
                                FILESERVER_ID = itemFile.ID,
                                KICHTHUOC = itemFile.FILE_SIZE,
                                TENFILE = itemFile.FILE_NAME
                            };
                            DataExtensions.Insert(hgFile);
                            deNghiKienNghi.FILEID = hgFile.ID;
                            File.Delete(strFilePath);
                            hddFilePathKN.Value = "";
                        }
                        catch (Exception ex) { lblThongBao.Text = ex.Message; }
                    }
                }
                if (idKN == 0)
                {
                    deNghiKienNghi.NGAYTAO = DateTime.Now;
                    deNghiKienNghi.NGUOITAO = userName;
                }
                else
                {
                    deNghiKienNghi.NGAYSUA = DateTime.Now;
                    deNghiKienNghi.NGUOISUA = userName;
                }
                bool isAction = false;
                if (idKN == 0)
                {
                    decimal isInsert = DataExtensions.Insert<HOAGIAI_DENGHI_KIENNGHI>(deNghiKienNghi);
                    if (isInsert != 0)
                    {
                        isAction = true;
                    }
                }
                else
                {
                    isAction = DataExtensions.Update<HOAGIAI_DENGHI_KIENNGHI>(deNghiKienNghi);
                }
                if (isAction)
                {
                    this.LoadGrid();
                    lblThongBao.Text = "Lưu thành công";
                    this.btnLammoi_Click(null, null);
                }
				else
				{
					lblThongBao.Text = "Có lỗi trong quá trình xử lý";
					return;
				}
			}
            catch
            {
                lblThongBao.Text = "Dữ liệu không đúng";
                throw new Exception("Dữ liệu không đúng");
            }
        }

        private void CheckValid(HOAGIAI_DENGHI_KIENNGHI deNghiKienNghi)
        {
            if (deNghiKienNghi.LOAIID == 1)
            {
                #region Đề nghị

                if (deNghiKienNghi.HINHTHUCNHANDON == null)
                {
                    lblThongBao.Text = "Hình thức nhận đơn không được để trống";
                    throw new Exception("Hình thức nhận đơn không được để trống");
                }
                if (deNghiKienNghi.NGAYVIETDON == null)
                {
                    lblThongBao.Text = "Ngày viết đơn không được để trống";
                    throw new Exception("Ngày viết đơn không được để trống");
                }

                #endregion Đề nghị
            }
            else
            {
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtKienNghiID.Text = "";
            rdbLoai.SelectedIndex = 0;
            rdbHinhThucNhanDon.SelectedIndex = 0;
            rdbKNCapkiennghi.SelectedIndex = 0;
            txtNgayTrenDon.Text = "";
            txtNgayDeNghi.Text = "";
            ddlNguoiDeNghi.SelectedIndex = 0;
            ddlQuyetDinh.SelectedIndex = 0;
            txtNoiDungDeNghi.Text = "";

            txtSoKN.Text = "";
            txtNgayKN.Text = "";
            rdbKNDonVi.SelectedIndex = 0;
            ddlDonViKN.SelectedIndex = 0;

            hddFilePath.Value = "";
            hddFilePathKN.Value = "";

            lbtDownloadDN.Text = "";
            lbtDownloadDN.Visible = false;
            lbtDownloadKN.Text = "";
            lbtDownloadKN.Visible = false;
            this.ddlNguoiDeNghi_SelectedIndexChanged(null, null);
            this.ddlQuyetDinh_SelectedIndexChanged(null, null);
            this.ddlNguoiDeNghi_SelectedIndexChanged(null, null);
            this.rdbLoai_SelectedIndexChanged(null, null);
        }

        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbLoai.SelectedValue == "1")//đề nghị
            {
                lbTitle.Text = "Thông tin đề nghị";
                pnlKienNghi.Visible = false;
                pnlDeNghi.Visible = true;
                this.ddlQuyetDinh_SelectedIndexChanged(null, null);
                //Cls_Comon.SetFocus(this, this.GetType(), ddlKNQuyetDinh.ClientID);
            }
            else //kiến nghị
            {
                lbTitle.Text = "Thông tin kiến nghị";
                pnlDeNghi.Visible = false;
                pnlKienNghi.Visible = true;
                this.ddlKNQuyetDinh_SelectedIndexChanged(null, null);
                //Cls_Comon.SetFocus(this, this.GetType(), txtNgayTrenDon.ClientID);
            }
        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
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

        protected void AsyncFileUpLoadKN_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKN.HasFile)
            {
                string strFileName = AsyncFileUpLoadKN.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKN.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePathKN.ClientID + "\").value = '" + path + "';", true);
            }
        }


        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal FileID = Convert.ToDecimal(hddFileid.Value);
            QT_FILE fileSR = DataExtensions.FindById<QT_FILE>(FileID);
            if (fileSR != null)
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                var NOIDUNG = fileHelper.GetNoiDungFile(fileSR, Convert.ToInt32(hddLoaiAn.Value));
                Context.Cache.Insert(key: cacheKey, value: NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileSR.FILE_NAME + "&Extension=" + fileSR.FILE_TYPE + "';", true);
            }
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

        #endregion "Phân trang"
    }
}