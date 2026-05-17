using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.DLQGC12;
using BL.GSTP.HOAGIAI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.HOAGIAI
{
    public partial class QuyetDinh : System.Web.UI.Page
    {
        private QT_FILE_BL fileHelper = new QT_FILE_BL();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
        private GSTPContext dt = new GSTPContext();
        public Decimal loaiAn = 0;
        public Decimal vuViecId = 0;
        private bool isUpdateAction = true;
        public string hoagiaitext = "hoà giải";
        private List<ListItem> lstDllKetQua;

        protected void Page_Load(object sender, EventArgs e)
        {
            string strMaCT = Session["MaChuongTrinh"] + "";
            string returnURL = "";
            string linhVuc = string.Empty;
            switch (strMaCT)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU].ToString());
                    linhVuc = ENUM_LOAIVUVIEC_TEXT.AN_DANSU;
                    break;

                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH].ToString());
                    linhVuc = ENUM_LOAIVUVIEC_TEXT.AN_HONNHAN_GIADINH;
                    //công nhận hòa giải thành
                    if (dllKetQua.SelectedValue == ((int)ENUM_CONGNHAN_HOAGIAI.CONGNHAN).ToString())
                        radioKetQua.Visible = true;
                    else
                        radioKetQua.Visible = false;
                    break;

                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI].ToString());
                    linhVuc = ENUM_LOAIVUVIEC_TEXT.AN_KINHDOANH_THUONGMAI;
                    break;

                case ENUM_LOAIAN.AN_LAODONG:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG].ToString());
                    linhVuc = ENUM_LOAIVUVIEC_TEXT.AN_LAODONG;
                    break;

                case ENUM_LOAIAN.AN_HANHCHINH:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH].ToString());
                    hoagiaitext = "đối thoại";
                    linhVuc = ENUM_LOAIVUVIEC_TEXT.AN_HANHCHINH;
                    break;

                default:
                    returnURL = "/Trangchu.aspx";
                    break;
            }
            if (vuViecId == 0) Response.Redirect(returnURL);
            hddLoaiAn.Value = loaiAn.ToString();
            hddVuViecId.Value = vuViecId.ToString();

            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();
            if (hoaGiaiDon != null)
                hddHoaGiaiId.Value = hoaGiaiDon.ID.ToString();
            else
                Response.Redirect(returnURL);

            this.lstDllKetQua = new List<ListItem>() {
                    new ListItem($"Công nhận {hoagiaitext} thành", ((int)ENUM_CONGNHAN_HOAGIAI.CONGNHAN).ToString()),
                    new ListItem($"Không công nhận {hoagiaitext} thành", ((int)ENUM_CONGNHAN_HOAGIAI.KHONGCONGNHAN).ToString()),
                };
            if (!IsPostBack)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                //Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);
                Cls_Comon.SetButton(btnXoa, oPer.XOA);
                this.isUpdateAction = checkQuyen();
                this.InitData(hoaGiaiDon);
                HOAGIAI_QUYETDINH quyetDinh = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {hoaGiaiDon.ID} ORDER BY NGAYTAO DESC").FirstOrDefault();
                if (quyetDinh != null)
                    loadEdit(quyetDinh.ID);
                //this.LoadGrid();


                // kiểm tra án hòa giải đã được đồng bộ lên chưa
                KHOBAQD_BL kHOBAQD_BL = new KHOBAQD_BL();
                if (kHOBAQD_BL.IsExistKHOBADQ(2, vuViecId, 2, linhVuc))
                {
                    lblThongBao.Text = "Bản án đã được đồng bộ, không được sửa đổi!";
                    btnUpdate.Enabled = false;
                    Cls_Comon.SetButton(btnUpdate, false);
                    btnXoa.Enabled = false;
                    Cls_Comon.SetButton(btnXoa, false);
                }
            }
            else
            {
                lblThongBao.Text = "";
            }
        }

        public bool checkQuyen()
        {
            var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
            if (checkPCTPQGD)
            {
                Cls_Comon.SetButton(btnUpdate, true);
            }
            else
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được phân công thẩm phán giải quyết đơn. Không được sửa!";
                return false;
            }
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
            var pctp = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
            if (pctp == null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Chưa phân công thẩm phán/Chỉ định hoà giải viên";
                return false;
            }

            var deNghiKienNghi = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
            if (deNghiKienNghi != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã có đề nghị/kiến nghị không được sửa đổi.";
                return false;
            }
            //HOAGIAI_GHINHANKETQUA
            var ghiNhanKetQua = DataExtensions.GetAllWithClause<HOAGIAI_GHINHANKETQUA>($"HOAGIAIID = {hoaGiaiDon.ID} AND KETQUAID = {(decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH}").FirstOrDefault();
            if (ghiNhanKetQua == null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc chưa có ghi nhận kết quả hòa giải là 'Hòa giải thành'";
                return false;
            }

            bool ds = false;
            if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber())
                ds = dt.ADS_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.ISDAIDIEN == 1 && (x.XACTHUC_DLDCQG != 1 && x.XACTHUC_DLDCQG != 3));
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber())
                ds = dt.AHN_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.ISDAIDIEN == 1 && (x.XACTHUC_DLDCQG != 1 && x.XACTHUC_DLDCQG != 3));
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI.toNumber())
                ds = dt.AKT_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.ISDAIDIEN == 1 && (x.XACTHUC_DLDCQG != 1 && x.XACTHUC_DLDCQG != 3));
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG.toNumber())
                ds = dt.ALD_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.ISDAIDIEN == 1 && (x.XACTHUC_DLDCQG != 1 && x.XACTHUC_DLDCQG != 3));
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber())
                ds = dt.AHC_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.ISDAIDIEN == 1 && (x.XACTHUC_DLDCQG != 1 && x.XACTHUC_DLDCQG != 3));

            if (ds)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Nguyên đơn, bị đơn đại diện chưa xác thực, vui lòng xác thực trước khi nhập quyết định!";
            }

            return true;

        }

        private void InitData(HOAGIAI_DON hgDon)
        {
            #region Kết quả hòa giải,đối thoại

            dllKetQua.Items.AddRange(lstDllKetQua.ToArray());
            this.dllKetQua_SelectedIndexChanged(null, null);

            #endregion Kết quả hòa giải,đối thoại

            #region Người ký, Chức vụ

            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();

            #region Lấy phân công với ngày nhận phân công là mới nhất

            HOAGIAI_THAMPHAN thamPhan = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hgDon.ID} AND THAMPHANID IS NOT NULL ORDER BY NGAYNHANPHANCONG DESC FETCH NEXT 1 ROWS ONLY ").FirstOrDefault();

            #endregion Lấy phân công với ngày nhận phân công là mới nhất

            if (thamPhan != null)
            {
                DataTable thamPhanInfor = oDMCBBL.DM_CANBO_GETINFOBYID(thamPhan.THAMPHANID ?? 0);
                if (thamPhanInfor.Rows.Count > 0)
                {
                    DataRow row = thamPhanInfor.Rows[0];
                    txtNguoiKy.Text = row["HOTEN"].ToString();
                    txtChuVu.Text = String.IsNullOrEmpty(row["CHUCDANH"].ToString()) ? row["CHUCVU"].ToString() : row["CHUCDANH"].ToString();
                }
            }

            #endregion Người ký, Chức vụ
        }

        private void LoadGrid()
        {
            //if (this.vuViecId == 0 || this.loaiAn == 0)
            //    return;
            //HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
            //var tbl = hoaGiaiBL.GetAllHoaGiaiQuyetDinh(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 0);
            //tbl.Columns.Add("KETQUATXT", typeof(System.String));

            //foreach (DataRow row in tbl.Rows)
            //{
            //    row["KETQUATXT"] = this.lstDllKetQua.FirstOrDefault(i => i.Value.ToString() == row["KETQUAID"].ToString()).Text;
            //}

            //dgList.CurrentPageIndex = 0;
            ////dgList.PageSize = page_size;
            //dgList.DataSource = tbl;
            //dgList.DataBind();
        }

        protected void dllKetQua_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                pnLyDoKhongCongNhan.Visible = false;

                ENUM_CONGNHAN_HOAGIAI congNhanHoaGiai = (ENUM_CONGNHAN_HOAGIAI)Enum.Parse(typeof(ENUM_CONGNHAN_HOAGIAI), dllKetQua.SelectedValue);

                if (congNhanHoaGiai == ENUM_CONGNHAN_HOAGIAI.KHONGCONGNHAN)
                {
                    pnLyDoKhongCongNhan.Visible = true;
                }
                var lstQuyetDinh = this.GetListQuyetDinhByLoaiQD(congNhanHoaGiai);
                //lstQuyetDinh.ForEach(x =>
                //{
                //    x.TEN = x.MA + " | " + x.TEN;
                //});
                dllTenQuyetDinh.DataSource = lstQuyetDinh;
                dllTenQuyetDinh.DataTextField = "TEN";
                dllTenQuyetDinh.DataValueField = "ID";
                dllTenQuyetDinh.DataBind();

                //công nhận hòa giải thành
                if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber() && dllKetQua.SelectedValue == ((int)ENUM_CONGNHAN_HOAGIAI.CONGNHAN).ToString())
                    radioKetQua.Visible = true;
                else
                    radioKetQua.Visible = false;
            }
            catch
            {
                throw new Exception("Có lỗi xảy ra hãy thử lại");
            }
        }

        private List<DM_QD_QUYETDINH> GetListQuyetDinhByLoaiQD(ENUM_CONGNHAN_HOAGIAI congNhanHoaGiai)
        {
            var qr = dt.DM_QD_QUYETDINH.AsQueryable();
            switch (this.loaiAn.ToString())
            {
                //dân sự
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    qr = qr.Where(x => x.ISDANSU == 1);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    qr = qr.Where(x => x.ISHNGD == 1);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    qr = qr.Where(x => x.ISKDTM == 1);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    qr = qr.Where(x => x.ISLAODONG == 1);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    qr = qr.Where(x => x.ISHANHCHINH == 1);
                    break;
            }
            string loaiQD = ENUM_DANHMUC.HGDT_HGT;
            if (congNhanHoaGiai == ENUM_CONGNHAN_HOAGIAI.KHONGCONGNHAN)
            {
                loaiQD = ENUM_DANHMUC.HGDT_HGKT;
            }
            qr = qr.Where(x => x.HIEULUC == 1);
            qr = qr.Join(
                dt.DM_QD_LOAI.Where(dm => dm.MA.Equals(loaiQD)).Where(dm => dm.HIEULUC == 1),
                qd => qd.LOAIID,
                loai => loai.ID,
                (qd, loai) => qd
            );
            return qr.ToList();
        }
        public void loadEdit(decimal id)
        {
            HOAGIAI_QUYETDINH quyetDinh = DataExtensions.FindById<HOAGIAI_QUYETDINH>(id);
            if (quyetDinh != null)
            {
                txtQuyetDinhId.Text = quyetDinh.ID.ToString();
                txtNgayHoaGiai.Text = quyetDinh.NGAYHOAGIAI?.ToVNDate().Replace("-", "/");
                txtDiaDiem.Text = quyetDinh.DIADIEM;
                dllKetQua.SelectedValue = quyetDinh.KETQUAID.ToString();
                this.dllKetQua_SelectedIndexChanged(null, null);
                dllTenQuyetDinh.SelectedValue = quyetDinh.QUYETDINHID?.ToString();
                if (quyetDinh.KETQUAID == (int)ENUM_CONGNHAN_HOAGIAI.KHONGCONGNHAN)
                {
                    txtLyDoKhongCongNhan.Text = quyetDinh.LYDO;
                }
                txtNguoiKy.Text = quyetDinh.NGUOIKY;
                txtChuVu.Text = quyetDinh.CHUCVU;
                txtNgayQD.Text = quyetDinh.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
                txtSoQD.Text = quyetDinh.SOQUYETDINH;

                #region Người ký, Chức vụ

                DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();

                #region Lấy phân công với ngày nhận phân công là mới nhất

                HOAGIAI_THAMPHAN thamPhan = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {quyetDinh.HOAGIAIID} AND THAMPHANID IS NOT NULL ORDER BY NGAYNHANPHANCONG DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                #endregion Lấy phân công với ngày nhận phân công là mới nhất

                if (thamPhan != null)
                {
                    DataTable thamPhanInfor = oDMCBBL.DM_CANBO_GETINFOBYID(thamPhan.THAMPHANID ?? 0);
                    if (thamPhanInfor.Rows.Count > 0)
                    {
                        DataRow row = thamPhanInfor.Rows[0];
                        txtNguoiKy.Text = row["HOTEN"].ToString();
                        txtChuVu.Text = String.IsNullOrEmpty(row["CHUCDANH"].ToString()) ? row["CHUCVU"].ToString() : row["CHUCDANH"].ToString();
                    }
                }

                #endregion Người ký, Chức vụ

                #region chấp nhận/không chấp nhận yêu cầu của đương sự (án hôn nhân)
                if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber())
                {
                    rdKetQua.SelectedValue = quyetDinh.TK_CHAPNHAN + "";
                }
                #endregion

                if ((quyetDinh.FILEID + "") != "" && (quyetDinh.FILEID + "") != "0")
                {
                    HOAGIAI_FILE hgFile = DataExtensions.FindById<HOAGIAI_FILE>(quyetDinh.FILEID.Value);
                    if (hgFile != null)
                    {
                        lbtDownload.Text = hgFile.TENFILE + hgFile.DUOIFILE;
                        lbtDownload.Visible = true;
                        hddFileid.Value = hgFile.FILESERVER_ID + "";
                    }
                }
                else
                {
                    lbtDownload.Text = "Tải file đính kèm";
                    lbtDownload.Visible = false;
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
                        lblThongBao.Text = "";
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(btnUpdate, false);
                        }
                        loadEdit(APID);
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
                            HOAGIAI_QUYETDINH quyetDinhHG = DataExtensions.FindById<HOAGIAI_QUYETDINH>(APID);
                            if (quyetDinhHG == null)
                            {
                                lblThongBao.Text = "Không tồn tại kết quả hòa giải";
                                return;
                            }
                            bool result = DataExtensions.Delete<HOAGIAI_QUYETDINH>(new HOAGIAI_QUYETDINH() { ID = APID });
                            if (quyetDinhHG.FILEID != null)
                            {
                                HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)quyetDinhHG.FILEID);
                                QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
                                QT_FILE_BL file_BL = new QT_FILE_BL();
                                file_BL.DeleteFileLogic(qT_FILE);
                            }
                            if (result)
                            {
                                HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {quyetDinhHG.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                                #region Nếu không có quyết định sẽ cập nhật lại trạng thái theo GHI NHẬN KẾT QUẢ

                                if (qdUPdateDon == null)
                                {
                                    HOAGIAI_GHINHANKETQUA ghiNhanKetQua = DataExtensions.GetAllWithClause<HOAGIAI_GHINHANKETQUA>($"HOAGIAIID = {quyetDinhHG.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                                    #region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                                    //Nếu không có cả ghi nhận kết quả thì chuyển trạng thái lại là HOA GIAI
                                    if (ghiNhanKetQua == null)
                                    {
                                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI);
                                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                                        Context.ApplicationInstance.CompleteRequest();
                                        lblThongBao.Text = "Xóa thành công!";
                                        return;
                                    }
                                    //end
                                    else if (ghiNhanKetQua.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                                    {
                                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ghiNhanKetQua.KETQUAID);
                                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                                        Context.ApplicationInstance.CompleteRequest();
                                        lblThongBao.Text = "Xóa thành công!";
                                        return;
                                    }

                                    #endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
                                }
                                else if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                                {
                                    this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
                                    Page.Response.Redirect(Page.Request.Url.ToString(), false);
                                    Context.ApplicationInstance.CompleteRequest();
                                    lblThongBao.Text = "Xóa thành công";
                                    return;
                                }

                                #endregion Nếu không có quyết định sẽ cập nhật lại trạng thái theo GHI NHẬN KẾT QUẢ

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
            if (e.Item.ItemType == ListItemType.Header)
            {
                e.Item.Cells[1].Text = "Ngày diễn ra phiên " + hoagiaitext;
            }
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                var isExistsFile = String.IsNullOrEmpty(row["FILESID"].ToString());
                if (isExistsFile)
                {
                    var button = (ImageButton)e.Item.FindControl("lblDownload");
                    //var lable = (System.Web.UI.WebControls.Label)e.Item.FindControl("lblKhongCoFile");
                    button.Visible = !isExistsFile;
                    //lable.Visible = isExistsFile;


                    if (this.isUpdateAction)
                    {
                        lblSua.Text = "Sửa";
                    }
                    else
                    {
                        lbtXoa.Visible = false;
                        lblSua.Text = "Chi tiết";
                    }
                    //loaiAn = Convert.ToDecimal(hddLoaiAn.Value);
                    //vuViecId = Convert.ToDecimal(hddVuViecId.Value);
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
                    //var checkThuLy = _hoaGiaiBl.CheckThuLy(vuViecId, loaiAn);
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

                }
                if (!Convert.ToBoolean(hddShowCommand.Value))
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                    Cls_Comon.SetButton(btnUpdate, false);
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (this.checkQuyen() == false)
                    return;
                string idQDStr = txtQuyetDinhId.Text;
                decimal idQD = 0;
                if (!String.IsNullOrEmpty(idQDStr))
                {
                    idQD = Convert.ToDecimal(idQDStr);
                }
                HOAGIAI_QUYETDINH quyetDinh = new HOAGIAI_QUYETDINH();
                if (idQD != 0)
                {
                    quyetDinh = DataExtensions.FindById<HOAGIAI_QUYETDINH>(idQD);
                    if (quyetDinh == null)
                    {
                        lblThongBao.Text = "Dữ liệu không đúng";
                        throw new Exception("Dữ liệu không đúng");
                    }
                }
                string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                quyetDinh.NGAYHOAGIAI = (String.IsNullOrEmpty(txtNgayHoaGiai.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHoaGiai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
                quyetDinh.DIADIEM = txtDiaDiem.Text;

                var congNhan = (ENUM_CONGNHAN_HOAGIAI)Enum.Parse(typeof(ENUM_CONGNHAN_HOAGIAI), dllKetQua.SelectedValue);

                quyetDinh.KETQUAID = (int)congNhan;

                if (congNhan == ENUM_CONGNHAN_HOAGIAI.KHONGCONGNHAN)
                {
                    quyetDinh.LYDO = txtLyDoKhongCongNhan.Text;
                }

                quyetDinh.NGAYQUYETDINH = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
                quyetDinh.SOQUYETDINH = txtSoQD.Text;

                if (idQD == 0)
                {
                    quyetDinh.NGAYTAO = DateTime.Now;
                    quyetDinh.NGUOITAO = userName;
                }
                else
                {
                    quyetDinh.NGAYSUA = DateTime.Now;
                    quyetDinh.NGUOISUA = userName;
                }
                quyetDinh.QUYETDINHID = Convert.ToDecimal(dllTenQuyetDinh.SelectedValue);
                this.CheckValid(quyetDinh);
                HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
                quyetDinh.HOAGIAIID = hg.ID;
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
                        quyetDinh.FILEID = hgFile.ID;
                        System.IO.File.Delete(strFilePath);
                        hddFilePath.Value = "";
                    }
                    catch (Exception ex) { lblThongBao.Text = ex.Message; }
                }

                #region Người ký, Chức vụ

                DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();

                #region Lấy phân công với ngày nhận phân công là mới nhất

                HOAGIAI_THAMPHAN thamPhan = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hg.ID} AND THAMPHANID IS NOT NULL ORDER BY NGAYNHANPHANCONG DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                #endregion Lấy phân công với ngày nhận phân công là mới nhất

                if (thamPhan != null)
                {
                    DataTable thamPhanInfor = oDMCBBL.DM_CANBO_GETINFOBYID(thamPhan.THAMPHANID ?? 0);
                    if (thamPhanInfor.Rows.Count > 0)
                    {
                        DataRow row = thamPhanInfor.Rows[0];
                        quyetDinh.NGUOIKY = row["HOTEN"].ToString();
                        quyetDinh.CHUCVU = String.IsNullOrEmpty(row["CHUCVU"].ToString()) ? row["CHUCDANH"].ToString() : row["CHUCVU"].ToString();
                    }
                }
                else
                {
                    lblThongBao.Text = "Không tồn tại phân công";
                    throw new MessageException("Không tồn tại phân công");
                }

                #endregion Người ký, Chức vụ

                #region chấp nhận/không chấp nhận yêu cầu của đương sự (án hôn nhân)
                if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber())
                {
                    if (dllKetQua.SelectedValue == ((int)ENUM_CONGNHAN_HOAGIAI.CONGNHAN).ToString())
                        quyetDinh.TK_CHAPNHAN = rdKetQua.SelectedValue != "" ? Convert.ToDecimal(rdKetQua.SelectedValue) : 4;
                    else
                        quyetDinh.TK_CHAPNHAN = null;
                }
                #endregion

                bool isAction = false;
                if (idQD == 0)
                {
                    decimal isInsert = DataExtensions.Insert<HOAGIAI_QUYETDINH>(quyetDinh);
                    if (isInsert != 0)
                    {
                        isAction = true;
                        txtQuyetDinhId.Text = quyetDinh.ID.ToString();
                    }
                }
                else
                {
                    isAction = DataExtensions.Update<HOAGIAI_QUYETDINH>(quyetDinh);
                }
                if (isAction)
                {
                    HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {quyetDinh.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                    #region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                    if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                    {
                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)quyetDinh.KETQUAID);
                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                        Context.ApplicationInstance.CompleteRequest();
                        lblThongBao.Text = "Lưu thành công";
                        return;
                    }

                    #endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                    this.LoadGrid();
                    lblThongBao.Text = "Lưu thành công";
                    //this.btnLammoi_Click(null, null);
                }
                else
                {
                    lblThongBao.Text = "Có lỗi trong quá trình xử lý";
                    return;
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Dữ liệu không đúng";
                throw new Exception("Dữ liệu không đúng");
            }
        }

        protected void btnXoa_Click(object sender, EventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.XOA == false || btnUpdate.Enabled == false)
                {
                    lblThongBao.Text = "Bạn không có quyền xóa!";
                    return;
                }
                string idQDStr = txtQuyetDinhId.Text;
                decimal idQD = 0;
                if (!String.IsNullOrEmpty(idQDStr))
                {
                    idQD = Convert.ToDecimal(idQDStr);
                }
                HOAGIAI_QUYETDINH quyetDinhHG = new HOAGIAI_QUYETDINH();
                if (idQD != 0)
                {
                    quyetDinhHG = DataExtensions.FindById<HOAGIAI_QUYETDINH>(idQD);
                    if (quyetDinhHG == null)
                    {
                        lblThongBao.Text = "Dữ liệu không đúng";
                        throw new Exception("Dữ liệu không đúng");
                    }
                }
                bool result = DataExtensions.Delete(quyetDinhHG);
                if (quyetDinhHG.FILEID != null)
                {
                    HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)quyetDinhHG.FILEID);
                    QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
                    QT_FILE_BL file_BL = new QT_FILE_BL();
                    file_BL.DeleteFileLogic(qT_FILE);
                }
                if (result)
                {
                    HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {quyetDinhHG.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                    #region Nếu không có quyết định sẽ cập nhật lại trạng thái theo GHI NHẬN KẾT QUẢ

                    if (qdUPdateDon == null)
                    {
                        HOAGIAI_GHINHANKETQUA ghiNhanKetQua = DataExtensions.GetAllWithClause<HOAGIAI_GHINHANKETQUA>($"HOAGIAIID = {quyetDinhHG.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

                        #region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

                        //Nếu không có cả ghi nhận kết quả thì chuyển trạng thái lại là HOA GIAI
                        if (ghiNhanKetQua == null)
                        {
                            this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI);
                            Page.Response.Redirect(Page.Request.Url.ToString(), false);
                            Context.ApplicationInstance.CompleteRequest();
                            lblThongBao.Text = "Xóa thành công!";
                            return;
                        }
                        //end
                        else if (ghiNhanKetQua.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                        {
                            this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ghiNhanKetQua.KETQUAID);
                            Page.Response.Redirect(Page.Request.Url.ToString(), false);
                            Context.ApplicationInstance.CompleteRequest();
                            lblThongBao.Text = "Xóa thành công!";
                            return;
                        }

                        #endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
                    }
                    else if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
                    {
                        this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
                        Page.Response.Redirect(Page.Request.Url.ToString(), false);
                        Context.ApplicationInstance.CompleteRequest();
                        lblThongBao.Text = "Xóa thành công";
                        this.ResetControls();
                        this.dllKetQua_SelectedIndexChanged(null, null);
                        return;
                    }

                    #endregion Nếu không có quyết định sẽ cập nhật lại trạng thái theo GHI NHẬN KẾT QUẢ

                    lblThongBao.Text = "Xóa thành công!";
                    this.ResetControls();
                    this.dllKetQua_SelectedIndexChanged(null, null);
                    //this.LoadGrid();
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
        }

        private void CheckValid(HOAGIAI_QUYETDINH quyetDinh)
        {
            if (quyetDinh.NGAYHOAGIAI == null)
            {
                lblThongBao.Text = "Ngày diễn ra phiên " + hoagiaitext + " không được để trống";
                throw new Exception("Ngày diễn ra phiên " + hoagiaitext + " không được để trống");
            }
            if (quyetDinh.KETQUAID == null)
            {
                lblThongBao.Text = "Kết quả không được để trống";
                throw new Exception("Kết quả không được để trống");
            }
            if (String.IsNullOrEmpty(quyetDinh.SOQUYETDINH))
            {
                lblThongBao.Text = "Số quyết định không được để trống";
                throw new Exception("Số quyết định không được để trống");
            }
            if (quyetDinh.NGAYQUYETDINH == null)
            {
                lblThongBao.Text = "Ngày quyết định không được để trống";
                throw new Exception("Ngày quyết định không được để trống");
            }
            if (quyetDinh.QUYETDINHID == null)
            {
                lblThongBao.Text = "Quyết định không được để trống";
                throw new Exception("Quyết định không được để trống");
            }

            #region Số quyết định

            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                //string so = txtSoQD.Text;

                //DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                //ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                //Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                //Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "ADS", so, ngay, LoaiQD);
                //if (CheckID > 0)
                //{
                //    String strMsg = "";
                //    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ADS", ngay, LoaiQD).ToString();
                //    Decimal CurrID = (string.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value);
                //    if (CheckID != CurrID)
                //    {
                //        strMsg = "Số Quyết định " + txtSoQD.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                //        txtSoQD.Text = STTNew;
                //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                //        txtSoQD.Focus();
                //        return false;
                //    }
                //}
            }

            #endregion Số quyết định
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            this.ResetControls();
            this.dllKetQua_SelectedIndexChanged(null, null);
        }

        private void ResetControls()
        {
            txtNgayHoaGiai.Text =
                txtDiaDiem.Text =
                txtLyDoKhongCongNhan.Text =
                txtNgayQD.Text =
                txtSoQD.Text = "";
            hddFilePath.Value = "";
            txtQuyetDinhId.Text = null;
            dllKetQua.SelectedIndex = 0;

            lbtDownload.Text = "";
            lbtDownload.Visible = false;
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
    }
}