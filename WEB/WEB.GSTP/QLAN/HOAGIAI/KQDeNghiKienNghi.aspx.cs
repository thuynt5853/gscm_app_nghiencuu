using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.HOAGIAI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.HOAGIAI
{
    public partial class KQDeNghiKienNghi : System.Web.UI.Page
    {
        private QT_FILE_BL fileHelper = new QT_FILE_BL();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal loaiAn = 0;
        public Decimal vuViecId = 0;
        private GSTPContext dt = new GSTPContext();
        private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
        private bool isUpdateAction = true;
        public string hoagiaitext = "hoà giải";

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
                    hoagiaitext = "đối thoại";
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
                //Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                //Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);
                this.isUpdateAction = this.checkQuyen();
                this.InitData();
                this.LoadGrid();
            }
        }

        public bool checkQuyen()
        {
            var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
            if (checkPCTPQGD)
            {
                //Cls_Comon.SetButton(btnUpdate, true);
            }
            else
            {
                //Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được phân công thẩm phán giải quyết đơn. Không được sửa!";
                return false;
            }
            var checkThuLy = _hoaGiaiBl.CheckThuLy(this.vuViecId, this.loaiAn);
            if (checkThuLy)
            {
                //Cls_Comon.SetButton(btnUpdate, true);
            }
            else
            {
                //Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được thụ lý. Không được sửa!";
                return false;
            }
            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {this.vuViecId} AND LOAIANID = {this.loaiAn}").FirstOrDefault();
            var deNghiKienNghi = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
            if (deNghiKienNghi == null)
            {
                //Cls_Comon.SetButton(btnUpdate, false);
                //Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc chưa có đề nghị/kiến nghị.";
                return false;
            }
            return true;
        }

        private void InitData()
        {
            DM_TOAAN toa = DataExtensions.FindById<DM_TOAAN>(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            this.LoadThamPhan(toa);
            this.LoadToaAnTrucThuoc(toa);
            this.LoadKetQuaDNKN();
        }

        private void LoadKetQuaDNKN()
        {
            ddlKetQuaDNKN.Items.Insert(0, new ListItem("Đình chỉ việc xem xét đề nghị, kiến nghị", "3"));
            ddlKetQuaDNKN.Items.Insert(0, new ListItem("Không chấp nhận đề nghị/kiến nghị, giữ nguyên QĐ công nhận KQ " + hoagiaitext + " thành", "2"));
            ddlKetQuaDNKN.Items.Insert(0, new ListItem("Huỷ QĐ công nhận HG/ĐT thành và giao cho toà án có thẩm quyền xem xét lại", "1"));
        }

        private void LoadThamPhan(DM_TOAAN toa)
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH((decimal)toa.CAPCHAID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "MA_TEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
        }

        private void LoadToaAnTrucThuoc(DM_TOAAN toa)
        {
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            if (toa != null && toa.CAPCHAID != null)
            {
                ddlToaAnTrucThuoc.DataSource = oBL.DM_TOAAN_GETBY((decimal)toa.CAPCHAID);
                ddlToaAnTrucThuoc.DataTextField = "arrTEN";
                ddlToaAnTrucThuoc.DataValueField = "ID";
                ddlToaAnTrucThuoc.DataBind();
            }

        }

        public void LoadGrid()
        {
            if (this.vuViecId == 0 || this.loaiAn == 0)
                return;
            HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
            var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 0);
            dgList.CurrentPageIndex = 0;
            dgList.DataSource = tbl;
            dgList.DataBind();
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
                            //Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            //Cls_Comon.SetButton(btnUpdate, false);
                        }
                        this.btnLammoi_Click(null, null);
                        HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(APID);
                        if (kqDNKN == null)
                        {
                            lblThongBao.Text = "Không tồn tại kết quả giải quyết đề nghị kiến nghị";
                            return;
                        }
                        txtKetQuaDNKNID.Text = kqDNKN.ID.ToString();
                        txtNgayGiao.Text = kqDNKN.NGAYGIAO?.ToVNDate().Replace("-", "/");
                        txtNgayNhan.Text = kqDNKN.NGAYNHAN?.ToVNDate().Replace("-", "/");
                        txtNgayQD.Text = kqDNKN.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
                        txtNgayThuLy.Text = kqDNKN.NGAYTHULY?.ToVNDate().Replace("-", "/");
                        txtSoQD.Text = kqDNKN.SOQUYETDINH;
                        txtSoThuLy.Text = kqDNKN.SOTHULY;
                        try
                        {
                            if (kqDNKN.QUYETDINHID != null)
                            {
                                ddlKetQuaDNKN.SelectedValue = kqDNKN.QUYETDINHID.ToString();
                            }
                            if (kqDNKN.THAMPHANID != null)
                            {
                                ddlThamphan.SelectedValue = kqDNKN.THAMPHANID.ToString();
                            }
                            if (kqDNKN.TOANHANID != null)
                            {
                                ddlToaAnTrucThuoc.SelectedValue = kqDNKN.TOANHANID.ToString();
                            }
                        }
                        catch
                        {
                            lblThongBao.Text = "Không thể sửa do có dữ liệu không hợp lệ";
                        }
                        break;

                        //    case "Xoa":
                        //        try
                        //        {
                        //            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        //            if (oPer.XOA == false || btnUpdate.Enabled == false)
                        //            {
                        //                lblThongBao.Text = "Bạn không có quyền xóa!";
                        //                return;
                        //            }
                        //            HOAGIAI_DENGHI_KIENNGHI_KETQUA ketQuadeNghiKienNghi = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(APID);
                        //            if (ketQuadeNghiKienNghi == null)
                        //            {
                        //                lblThongBao.Text = "Không tồn tại kết quả giải quyết đề nghị kiến nghị";
                        //                return;
                        //            }
                        //            bool result = DataExtensions.Delete<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(new HOAGIAI_DENGHI_KIENNGHI_KETQUA() { ID = APID });
                        //            //if (deNghiKienNghi.FILEID != null)
                        //            //{
                        //            //    HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)deNghiKienNghi.FILEID);
                        //            //    QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
                        //            //    QT_FILE_BL file_BL = new QT_FILE_BL();
                        //            //    file_BL.DeleteFileLogic(qT_FILE);
                        //            //}
                        //            if (result)
                        //            {
                        //                HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                        //                if (kqDnKnUpdateDon != null)
                        //                {
                        //                    #region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                        //                    int ketQuaID = 0;
                        //                    if (kqDnKnUpdateDon.QUYETDINHID == 1)
                        //                        ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
                        //                    if (kqDnKnUpdateDon.QUYETDINHID == 2)
                        //                        ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
                        //                    if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                        //                    {
                        //                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
                        //                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                        //                        Context.ApplicationInstance.CompleteRequest();
                        //                        lblThongBao.Text = "Xóa thành công!";
                        //                        return;
                        //                    }
                        //                    else if (ketQuaID == 0)
                        //                    {
                        //                        //Cập nhật lại theo QD
                        //                        HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
                        //                        if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                        //                        {
                        //                            this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
                        //                            Page.Response.Redirect(Page.Request.Url.ToString(), false);
                        //                            Context.ApplicationInstance.CompleteRequest();
                        //                            lblThongBao.Text = "Xóa thành công!";
                        //                            return;
                        //                        }
                        //                    }
                        //                }
                        //                else
                        //                {
                        //                    HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
                        //                    if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                        //                    {
                        //                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
                        //                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                        //                        Context.ApplicationInstance.CompleteRequest();
                        //                        lblThongBao.Text = "Xóa thành công!";
                        //                        return;
                        //                    }
                        //                }

                        //                #endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                        //                lblThongBao.Text = "Xóa thành công!";
                        //                this.LoadGrid();
                        //            }
                        //            else
                        //            {
                        //                lblThongBao.Text = "Không thể xóa hãy thử lại";
                        //            }
                        //        }
                        //        catch (Exception ex)
                        //        {
                        //            lblThongBao.Text = ex.Message;
                        //        }
                        //        break;
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
                //var isExistsFile = String.IsNullOrEmpty(row["FILESID"].ToString());
                //if (isExistsFile)
                //{
                //    var button = (ImageButton)e.Item.FindControl("lblDownload");
                //    //var lable = (System.Web.UI.WebControls.Label)e.Item.FindControl("lblKhongCoFile");
                //    button.Visible = !isExistsFile;
                //    //lable.Visible = isExistsFile;
                //}

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                lblSua.Text = "Chi tiết";

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                lbtXoa.Visible = false;
                //Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                //if (this.isUpdateAction)
                //{
                //    lblSua.Text = "Sửa";
                //}
                //else
                //{
                //    lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
                //var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
                //if (checkPCTPQGD)
                //{
                //    lblSua.Visible = lbtXoa.Visible = true;
                //    lblSua.Text = "Sửa";
                //}
                //else
                //{
                //    lblSua.Visible = lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
                //var checkThuLy = _hoaGiaiBl.CheckThuLy(this.vuViecId, this.loaiAn);
                //if (checkThuLy)
                //{
                //    lblSua.Visible = lbtXoa.Visible = true;
                //    lblSua.Text = "Sửa";
                //}
                //else
                //{
                //    lblSua.Visible = lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
                //if (!Convert.ToBoolean(hddShowCommand.Value))
                //{
                //    lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (this.checkQuyen() == false)
                    return;
                string idQDStr = txtKetQuaDNKNID.Text;
                decimal idQD = 0;
                if (!String.IsNullOrEmpty(idQDStr))
                {
                    idQD = Convert.ToDecimal(idQDStr);
                }
                HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
                if (idQD != 0)
                {
                    kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);
                    if (kqDNKN == null)
                    {
                        lblThongBao.Text = "Dữ liệu không đúng";
                        throw new Exception("Dữ liệu không đúng");
                    }
                }
                string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                //   quyetDinh.NGAYHOAGIAI = (String.IsNullOrEmpty(txtNgayHoaGiai.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHoaGiai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
                kqDNKN.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                kqDNKN.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                kqDNKN.THAMPHANID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                kqDNKN.TOANHANID = Convert.ToDecimal(ddlToaAnTrucThuoc.SelectedValue);
                kqDNKN.QUYETDINHID = Convert.ToDecimal(ddlKetQuaDNKN.SelectedValue);
                kqDNKN.NGAYQUYETDINH = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                kqDNKN.SOQUYETDINH = txtSoQD.Text.Trim().ToString();
                kqDNKN.SOTHULY = txtSoThuLy.Text.Trim().ToString();
                kqDNKN.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                bool isVaild = this.CheckValid(kqDNKN);
                if (!isVaild)
                    return;
                HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
                kqDNKN.HOAGIAIID = hg.ID;
                //if (hddFilePath.Value != "")
                //{
                //    try
                //    {
                //        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                //        QT_FILE itemFile = fileHelper.InsertFile(strFilePath, Convert.ToInt32(hddLoaiAn.Value));
                //        HOAGIAI_FILE hgFile = new HOAGIAI_FILE()
                //        {
                //            DUOIFILE = itemFile.FILE_TYPE,
                //            FILESERVER_ID = itemFile.ID,
                //            KICHTHUOC = itemFile.FILE_SIZE,
                //            TENFILE = itemFile.FILE_NAME
                //        };
                //        DataExtensions.Insert(hgFile);
                //        kqDNKN.FILEID = hgFile.ID;
                //        System.IO.File.Delete(strFilePath);
                //        hddFilePath.Value = "";
                //    }
                //    catch (Exception ex) { lblThongBao.Text = ex.Message; }
                //}
                if (idQD == 0)
                {
                    kqDNKN.NGAYTAO = DateTime.Now;
                    kqDNKN.NGUOITAO = userName;
                }
                else
                {
                    kqDNKN.NGAYSUA = DateTime.Now;
                    kqDNKN.NGUOISUA = userName;
                }
                bool isAction = false;
                if (idQD == 0)
                {
                    decimal isInsert = DataExtensions.Insert<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
                    if (isInsert != 0)
                    {
                        isAction = true;
                    }
                }
                else
                {
                    isAction = DataExtensions.Update<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
                }
                if (isAction)
                {
                    HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                    #region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                    int ketQuaID = 0;
                    if (kqDnKnUpdateDon.QUYETDINHID == 1)
                        ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
                    if (kqDnKnUpdateDon.QUYETDINHID == 2)
                        ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
                    if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                    {
                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                        Context.ApplicationInstance.CompleteRequest();
                        lblThongBao.Text = "Lưu thành công";
                        return;
                    }
                    else if (ketQuaID == 0)
                    {
                        //Cập nhật lại theo QD
                        HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
                        if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                        {
                            this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
                            Page.Response.Redirect(Page.Request.Url.ToString(), false);
                            Context.ApplicationInstance.CompleteRequest();
                            lblThongBao.Text = "Lưu thành công";
                            return;
                        }
                    }

                    #endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

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

        private bool CheckValid(HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN)
        {
            if (kqDNKN.NGAYGIAO == null)
            {
                lblThongBao.Text = "Ngày giao không được để trống";
                return false;
            }
            if (kqDNKN.NGAYNHAN == null)
            {
                lblThongBao.Text = "Ngày nhận không được để trống";
                return false;
            }
            if (kqDNKN.THAMPHANID == null)
            {
                lblThongBao.Text = "Thẩm phán không được để trống";
                return false;
            }
            if (kqDNKN.TOANHANID == null)
            {
                lblThongBao.Text = "Tòa án không được để trống";
                return false;
            }
            if (kqDNKN.QUYETDINHID == null)
            {
                lblThongBao.Text = "Kết quả không được để trống";
                return false;
            }
            if (kqDNKN.NGAYQUYETDINH == null)
            {
                lblThongBao.Text = "Ngày quyết định không được để trống";
                return false;
            }
            if (kqDNKN.SOQUYETDINH == null)
            {
                lblThongBao.Text = "Số quyết định không được để trống";
                return false;
            }
            if (kqDNKN.SOTHULY == null)
            {
                lblThongBao.Text = "Số thụ lý không được để trống";
                return false;
            }
            if (kqDNKN.NGAYTHULY == null)
            {
                lblThongBao.Text = "Ngày thụ lý không được để trống";
                return false;
            }
            return true;
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtNgayGiao.Text =
                txtNgayNhan.Text =
                txtSoQD.Text =
                txtNgayQD.Text = "";
            ddlKetQuaDNKN.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;
            ddlToaAnTrucThuoc.SelectedIndex = 0;
            txtSoThuLy.Text = "";
        }

        //protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        //{
        //    if (AsyncFileUpLoad.HasFile)
        //    {
        //        string strFileName = AsyncFileUpLoad.FileName;
        //        string path = Server.MapPath("~/TempUpload/") + strFileName;
        //        AsyncFileUpLoad.SaveAs(path);

        //        path = path.Replace("\\", "/");
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
        //    }
        //}

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