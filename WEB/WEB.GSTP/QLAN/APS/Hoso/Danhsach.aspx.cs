using BL.GSTP;
using BL.GSTP.APS;
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
using DAL.DKK;
using System.Web.Script.Serialization;


namespace WEB.GSTP.QLAN.APS.Hoso
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch
            { return false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strSearch = Session["textsearch"] + "";
                if (strSearch != "")
                {
                    txtTenViec.Text = strSearch;
                    Session["textsearch"] = "";
                    LoadCombobox();
                    Load_Data();
                }
                else
                {
                   // ddlTinhTrangGQ.SelectedValue = "1";
                    LoadCombobox();
                    //Load_Data();
                }

                dgList.Columns[2].Visible = false;
                cmdNhapan.Visible = false;
                cmdTachan.Visible = false;

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    cmdThemmoi.Visible = false;
                }
                else
                {
                    Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
        }
        private void CheckChucDanhUser(ref decimal vCheckTk)
        {
            //DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
            //int counttk = oCBDT.Rows.Count;
            //if (counttk > 0)
            //{
            //    //là thư ký
            //    //kiểm tra user có thuộc hCTP hay không

            //    //kiểm  tra có phải là thư ký hay không


            //    decimal IdNhomNguoiSuDung = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID]);
            //    decimal CurrentUserId = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
            //    int count = dt.QT_NHOMNGUOIDUNG.Count(s => s.ID == IdNhomNguoiSuDung && (s.TEN.Contains("HCTP") || s.TEN.Contains("TAND")));
            //    if (count > 0)
            //    {
            //        //là thư ký của HCTP
            //        vCheckTk = 0;
            //    }
            //    else
            //    {
            //        vCheckTk = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
            //        //không là thư ký của hành chính tư pháp
            //        ///kiếm tra thư ký có quyền được xem hay không
            //        //foreach (DataRow item in dataTable.Rows)
            //        //{
            //        //    decimal DonID = Convert.ToDecimal(item["ID"]);
            //        //    int countItem = dt.APS_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == DonID);
            //        //    if (countItem > 0)
            //        //    {
            //        //        //thư ký được xem vụ án này

            //        //    }
            //        //    else
            //        //    {
            //        //        //thư ký không được xem vụ án này
            //        //        item.Delete();
            //        //    }
            //        //}
            //        //dataTable.AcceptChanges();
            //    }
            //}
            //else
            //{
            //    vCheckTk = 0;
            //}

        }


        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtTenViec.Text = "";
            txtMaViec.Text = "";
            ddlLoaiHinhDoanhNghiep.SelectedIndex = 0;
            txtDuongSu_NguoiThamGiaToTung.Text = "";
            ddlCapXetXu.SelectedIndex = 0;
            ddlToaAnXetXu.SelectedIndex = 0;
            ddlTinhTrangThuLy.SelectedValue = "";
            txtTuNgayThuly.Text = "";
            txtDenNgayThuLy.Text = "";
            txtSoThuLy.Text = "";
            ddlTinhTrangGQ.SelectedValue = "";
            txtTuNgayTinhTrangGQ.Text = "";
            txtDenNgayTinhTrangGQ.Text = "";
            ddlThamphan.SelectedIndex = 0;
            ddlThoiHanGQ.SelectedValue = "";
            txtSoQD.Text = "";
            txtNgayQD.Text = "";
            ddlThuKy.SelectedIndex = 0;
            ddlGQDon.SelectedValue = "";
            ddlUyThacTuPhap.SelectedValue = "";
            ddlPTRutKinhNghiem.SelectedValue = "";
        }

        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
           /* DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            ddlQuanhephapluat.Items.Insert(0, new ListItem("-- Tất cả --", "0"));*/
            //--------------------
            LoadDropThamphan();

            // duongph 23/03/2022
            //Loại hình doanh nghiệp
            ddlLoaiHinhDoanhNghiep.Items.Clear();
            ddlLoaiHinhDoanhNghiep.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN).OrderBy(y => y.ARRTHUTU).ToList();
            ddlLoaiHinhDoanhNghiep.DataTextField = "CASE_NAME";
            ddlLoaiHinhDoanhNghiep.DataValueField = "ID";
            ddlLoaiHinhDoanhNghiep.DataBind();
            ddlLoaiHinhDoanhNghiep.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            //Cấp xét xử
            ddlCapXetXu.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ck_GQTDC_QDK.Enabled = false;
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                ddlCapXetXu.Items.Add(new ListItem("-- Tất cả --", ""));
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                ddlCapXetXu.Items.Add(new ListItem("-- Tất cả --", ""));
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //Tòa án xét xử
            LoadDropToaAnXetXu();
            LoadDropThuKy();
        }
        private void LoadDropToaAnXetXu()
        {
            ddlToaAnXetXu.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            ddlToaAnXetXu.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", ddlCapXetXu.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            ddlToaAnXetXu.DataTextField = "arrTEN";
            ddlToaAnXetXu.DataValueField = "ID";
            ddlToaAnXetXu.DataBind();
            if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
            {
                ddlToaAnXetXu.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            }
            LoadDropThuKy();
        }
        void LoadDropThamphan()
        {
            Boolean IsLoadAll = true;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
            // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault<DM_CANBO>();
            if (oCB != null)
            {
                // Kiểm tra chức danh có là thẩm phán hay không
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA.Contains("TP"))
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay khôngm c
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.MA.Contains("CA"))
                    {
                        IsLoadAll = true;
                    }
                }
            }
            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();
                decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
            loadDropVaiTroThamPhan();
        }
        void loadDropVaiTroThamPhan()
        {
            ddlVaiTroThamPhan.Items.Clear();
            ddlVaiTroThamPhan.Items.Add(new ListItem("-- Tất cả --", ""));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết đơn", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETDON));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết vụ việc", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETVUVIEC));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlThamphan.SelectedValue == null || ddlThamphan.SelectedValue == "")
                ddlVaiTroThamPhan.SelectedValue = String.Empty;
        }
        protected void LoadDropThuKy()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (ddlToaAnXetXu.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(ddlToaAnXetXu.SelectedValue, null);
            ddlThuKy.DataSource = tbl;
            ddlThuKy.DataTextField = "MA_TEN";
            ddlThuKy.DataValueField = "ID";
            ddlThuKy.DataBind();
            ddlThuKy.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }

        private void Load_Data()
        {
            decimal vchecktk = 0;
            CheckChucDanhUser(ref vchecktk);
            APS_DON_BL oBL = new APS_DON_BL();
            //duongph 23/03/2022
            /* decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                     ThamPhanId = Convert.ToDecimal(ddlThamphan.SelectedValue),
                     LoaiQuanHe = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue),
                     QHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue),
                     GiaiDoan = Convert.ToDecimal(ddlGiaiDoan.SelectedValue),
                     HinhThucNhanDon = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue),
                     dSothutu = txtSothutu.Text.Trim() == "" ? 0 : Convert.ToDecimal(txtSothutu.Text.Trim()),
                     PhanCongTP = Convert.ToDecimal(ddlPhanCongTP.SelectedValue);
             string vUTTP = dropUTTP.SelectedValue;
             DateTime? dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault),
                       dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
             string MaVuViec = txtMaVuViec.Text.Trim(),
                    TenVuViec = txtTenVuViec.Text.Trim(),
                    Tenduongsu = txtTenduongsu.Text.Trim();*/
            string vDonViID = Convert.ToString(Session[ENUM_SESSION.SESSION_DONVIID]),
                    LoaiHinhDoanhNghiep = ddlLoaiHinhDoanhNghiep.SelectedValue,
                    CapXetXu = ddlCapXetXu.SelectedValue,
                    ToaXetXu = ddlToaAnXetXu.SelectedValue,
                    TinhTrangThuLy = ddlTinhTrangThuLy.SelectedValue,
                    TinhTrangGQ = ddlTinhTrangGQ.SelectedValue,
                    ThamPhan = ddlThamphan.SelectedValue,
                    ThoiHanGQ = ddlThoiHanGQ.SelectedValue,
                    ThuKy = ddlThuKy.SelectedValue,
                    GQDon = ddlGQDon.SelectedValue,
                    UyThacTuPhap = ddlUyThacTuPhap.SelectedValue,
                    PTRutKinhNghiem = ddlPTRutKinhNghiem.SelectedValue;
            //string vUTTP = dropUTTP.SelectedValue;
            /*DateTime? dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault),
                      dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);*/
            string tuNgayThuLy = txtTuNgayThuly.Text.Trim(), denNgayThuLy = txtDenNgayThuLy.Text.Trim();
            string tuNgayTinhTrangGQ = txtTuNgayTinhTrangGQ.Text.Trim(), denNgayTinhTrangGQ = txtDenNgayTinhTrangGQ.Text.Trim();
            string ngayQD = txtNgayQD.Text.Trim();
            /*string MaVuViec = txtMaVuViec.Text.Trim(),
                   TenVuViec = txtTenVuViec.Text.Trim(),
                   Tenduongsu = txtTenduongsu.Text.Trim();*/
            string tenViec = txtTenViec.Text,
                   maViec = txtMaViec.Text,
                   duongSu_NguoiThamGiaToTung = txtDuongSu_NguoiThamGiaToTung.Text,
                   soThuLy = txtSoThuLy.Text,
                   soQD = txtSoQD.Text;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0,
                trangThaiVuAn = Convert.ToInt32(ddlTrangThaiVuAn.SelectedValue);
            /*DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
            int count = oCBDT.Rows.Count;
            decimal ThuKyID = 0;
            if (count > 0)
            {
                ThuKyID = Convert.ToDecimal(oCBDT.Rows[0]["ID"]);
            }*/
            //DataTable oDT = oBL.APS_DON_SEARCH(vDonViID, MaVuViec, TenVuViec, dFrom, dTo, LoaiQuanHe, QHPL, dSothutu, Tenduongsu, GiaiDoan, HinhThucNhanDon, ThamPhanId, ThuKyID, PhanCongTP, vUTTP, vchecktk, pageindex, page_size);
            DataTable oDT = oBL.APS_DON_SEARCH_V2(Session["CAP_XET_XU"] + "", vDonViID, tenViec, LoaiHinhDoanhNghiep, maViec, duongSu_NguoiThamGiaToTung, CapXetXu, ToaXetXu, TinhTrangThuLy, tuNgayThuLy, denNgayThuLy, soThuLy, TinhTrangGQ, tuNgayTinhTrangGQ, denNgayTinhTrangGQ, ThamPhan, ThoiHanGQ, soQD, ngayQD, ThuKy, GQDon, UyThacTuPhap, PTRutKinhNghiem, vchecktk, ck_GQTDC_QDK.Checked == true ? 1 : 0, ddlVaiTroThamPhan.SelectedValue, Convert.ToDecimal(DropMA_THONG_BAO.SelectedValue), pageindex, page_size);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = oDT;
            dgList.DataBind();
        }


        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            int status = Convert.ToInt32(ddlTrangThaiVuAn.SelectedValue);
            if (status == 0)
            {
                hddPageIndex.Value = "1";
                Load_Data();

                dgList.Columns[2].Visible = true;
                dgList.Columns[3].Visible = true;
                dgList.Columns[8].Visible = true;
            }
            else
            {
                dgList.Columns[2].Visible = false;
                dgList.Columns[3].Visible = false;
                dgList.Columns[8].Visible = false;

                //Search
                APS_DON_BL oBL = new APS_DON_BL();
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                    pageindex = Convert.ToInt32(hddPageIndex.Value),
                    count_all = 0;

                string vDonViID = Convert.ToString(Session[ENUM_SESSION.SESSION_DONVIID]),
                    CapXetXu = ddlCapXetXu.SelectedValue,
                    ToaXetXu = ddlToaAnXetXu.SelectedValue,
                    TinhTrangThuLy = ddlTinhTrangThuLy.SelectedValue,
                    ThamPhan = ddlThamphan.SelectedValue,
                    ThuKy = ddlThuKy.SelectedValue;

                string tenViec = txtTenViec.Text,
                   maViec = txtMaViec.Text,
                   duongSu_NguoiThamGiaToTung = txtDuongSu_NguoiThamGiaToTung.Text,
                   soThuLy = txtSoThuLy.Text;

                string tuNgayThuLy = txtTuNgayThuly.Text.Trim(),
                    denNgayThuLy = txtDenNgayThuLy.Text.Trim();

                DataTable oDT = oBL.DON_NHAPTACH_SEARCH(Session["CAP_XET_XU"] + "", tenViec, "", maViec, duongSu_NguoiThamGiaToTung, CapXetXu, ToaXetXu, TinhTrangThuLy, soThuLy, tuNgayThuLy, denNgayThuLy, ThamPhan, ThuKy, "", status, 7, pageindex, page_size);

                if (oDT != null && oDT.Rows.Count > 0)
                {
                    foreach (DataRow item in oDT.Rows)
                    {
                        decimal donConID = Convert.ToDecimal(item["ID"].ToString());
                        DON_NHAPTACH dNT = dt.DON_NHAPTACH.Where(x => x.ID == donConID).FirstOrDefault();
                        if (dNT != null && status == 1)
                        {
                            APS_DON dGoc = dt.APS_DON.Where(x => x.ID == dNT.VUANGOCID).FirstOrDefault();
                            string tempGQ = item["TINHTRANG_GQ"].ToString();
                            if (dGoc != null)
                            {
                                tempGQ = "- Đã nhập vào vụ việc: <b>" + dGoc.MAVUVIEC + "</b><br>" + tempGQ;
                            }
                            else
                            {
                                tempGQ = "- Đã nhập vào vụ việc: <b>" + "</b><br>" + tempGQ;
                            }
                            item["TINHTRANG_GQ"] = tempGQ;
                        }
                    }

                    count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                    #region "Xác định số lượng trang"
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    #endregion
                }
                else
                {
                    hddTotalPage.Value = "1";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }
                dgList.PageSize = page_size;
                dgList.DataSource = oDT;
                dgList.DataBind();
            }
        }


        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            //---huy vu an da ghim
            Decimal IDVuViec = 0;
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
            oNSD.IDANPHASAN = IDVuViec;
            dt.SaveChanges();
            Session[ENUM_LOAIAN.AN_PHASAN] = IDVuViec;
            //-----------------------
            Session["PS_THEMDSK"] = null;
            Response.Redirect("Thongtindon.aspx?type=new");

        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDVuViec = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Select"://Lựa chọn vụ việc cần Lưu thông tin

                    //Lưu vào người dùng
                    decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                    {
                        oNSD.IDANPHASAN = IDVuViec;
                        dt.SaveChanges();
                    }
                    Session[ENUM_LOAIAN.AN_PHASAN] = IDVuViec;
                    APS_DON oDon = dt.APS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon.TOAANID == oNSD.DONVIID && (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT))
                        Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Vụ việc đã được chuyển lên cấp trên, các thông tin sẽ không được phép thay đổi !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    else
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Bạn đã chọn vụ việc, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "Sua":
                    Response.Redirect("Thongtindon.aspx?type=list&ID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    var json = new JavaScriptSerializer().Serialize(oT);

                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID]+""=="1")
                    {
                        ADS_DON_BL oBL1 = new ADS_DON_BL();
                        //Luu thong tin ho so vu an khi xoa
                        if (oBL1.HISTORY_ALLDATA_BY_VUANID(IDVuViec, 7, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Danh sách án Phá sản", "Xóa", json) == false)
                        {
                            lbtthongbao.Text = "Lỗi khi lưu lịch sử khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                        else
                        {
                            lbtthongbao.Text = "Xóa thành công !";
                        }

                        APS_DON_BL oBL = new APS_DON_BL();
                        if (oBL.DELETE_ALLDATA_BY_VUANID(IDVuViec + "") == true)
                        {
                            //anhvh add 26/06/2020
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GIAIDOAN_DELETES("7", IDVuViec,2);
                            if (oT.HINHTHUCNHANDON == 3)//Trực tuyến
                            {
                                //la don truc tuyen --> cho phep phan loai lai donkk
                                try { PhanLoaiLai_DonKK(oPer, IDVuViec); } catch { }
                            }
                        }
                        else
                        {
                            lbtthongbao.Text = "Lỗi khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                    }
                    else
                    {
                        Xoa_An(oPer, IDVuViec);
                        if (IDVuViec == VuAnID)
                            Session[ENUM_LOAIAN.AN_PHASAN] = 0;
                    }
                    decimal IDUser_ = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    //để sửa lỗi mất menu khi xóa vụ án, anhvh add trường hợp xóa vụ án và uppdate lại idvuan =0 để giải phóng việc gim vụ án
                    QT_NGUOISUDUNG oNSD_ = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser_).FirstOrDefault();
                    if (oNSD_.IDANPHASAN == IDVuViec)
                    {
                        oNSD_.IDANPHASAN = 0;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }
        }
        void Xoa_An(MenuPermission oPer, decimal IDVuViec)
        {
            if (oPer.XOA == false)
            {
                lbtthongbao.Text = "Bạn không có quyền xóa!";
                return;
            }
            APS_DON oT = dt.APS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
            if (oT != null)
            {
                int GiaiDoan = (int)oT.MAGIAIDOAN;
                if (GiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    #region Kiểm tra dữ liệu liên quan
                    // Kiểm tra Án phí
                    APS_ANPHI anphi = dt.APS_ANPHI.Where(x => x.DONID == IDVuViec).FirstOrDefault<APS_ANPHI>();
                    if (anphi != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu thông tin biên lai án phí, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra giải quyết đơn
                    APS_DON_XULY xld = dt.APS_DON_XULY.Where(x => x.DONID == IDVuViec).FirstOrDefault<APS_DON_XULY>();
                    if (xld != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu giải quyết đơn, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra thẩm phán giải quyết đơn
                    APS_DON_THAMPHAN gqd = dt.APS_DON_THAMPHAN.Where(x => x.DONID == IDVuViec && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault<APS_DON_THAMPHAN>();
                    if (gqd != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu thẩm phán giải quyết đơn. Không được xóa.";
                        return;
                    }
                    // Kiểm tra Giao nhận tài liệu chứng cứ
                    APS_DON_TAILIEU tailieu = dt.APS_DON_TAILIEU.Where(x => x.DONID == IDVuViec).FirstOrDefault<APS_DON_TAILIEU>();
                    if (tailieu != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu giao nhận tài liệu chứng cứ, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra người tham gia tố tụng khác
                    APS_DON_THAMGIATOTUNG tgtt = dt.APS_DON_THAMGIATOTUNG.Where(x => x.DONID == IDVuViec).FirstOrDefault<APS_DON_THAMGIATOTUNG>();
                    if (tgtt != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu người tham gia tố tụng khác, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra danh sách đương sự
                    //APS_DON_DUONGSU ds = dt.APS_DON_DUONGSU.Where(x => x.DONID == IDVuViec && x.ISDAIDIEN != 1).FirstOrDefault<APS_DON_DUONGSU>();
                    //if (ds != null)
                    //{
                    //    lbtthongbao.Text = "Vụ việc đã có dữ liệu trong danh sách đương sự, không được phép xóa!";
                    //    return;
                    //}
                    //K: Nếu vụ việc đã có đơn con thì không cho xoá
                    DON_CHITIET dct = dt.DON_CHITIET.Where(x => x.DONID == IDVuViec && x.LOAIANID == 7).FirstOrDefault();
                    DON_KHAC dk = dt.DON_KHAC.Where(x => x.DONID == IDVuViec && x.LOAIANID == 7).FirstOrDefault();
                    if (dct != null && dk != null)
                    {
                        lbtthongbao.Text = "Vụ việc đang có đơn, không được xoá!";
                        return;
                    }
                    #endregion

                    List<APS_FILE> lstF = dt.APS_FILE.Where(x => x.DONID == IDVuViec).ToList<APS_FILE>();
                    if (lstF.Count > 0)
                    {
                        foreach (APS_FILE f in lstF)
                        {
                            dt.APS_FILE.Remove(f);
                        }
                        dt.SaveChanges();
                    }

                    var delete_all_record_APS_DON_DUONGSU_by_donid = dt.APS_DON_DUONGSU.Where(x => x.DONID == IDVuViec);
                    dt.APS_DON_DUONGSU.RemoveRange(delete_all_record_APS_DON_DUONGSU_by_donid);

                    dt.APS_DON.Remove(oT);
                    dt.SaveChanges();

                    //K: Nếu vụ việc tồn tại trong bảng DON_TIEPNHAN thì cập nhật trạng thái DON_GUINHAN = 4
                    DON_TIEPNHAN dtn = dt.DON_TIEPNHAN.Where(x => x.DONID == IDVuViec && x.LOAIAN == 7).FirstOrDefault();
                    if (dtn != null)
                    {
                        DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == dtn.DONGUINHANID).FirstOrDefault();
                        if (dgn != null)
                        {
                            dgn.TRANGTHAI = 4;
                            dt.SaveChanges();
                        }
                    }

                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GIAIDOAN_DELETES("7", IDVuViec,2);
                    //---------------------------
                    if (oT.HINHTHUCNHANDON == 3)
                    {
                        //la don truc tuyen --> cho phep phan loai lai donkk
                        try { PhanLoaiLai_DonKK(oPer, IDVuViec); } catch (Exception ex) { }
                    }
                }
            }
        }

        void PhanLoaiLai_DonKK(MenuPermission oPer, decimal IDVuViec)
        {
            String MaLoaiVuAn = ENUM_LOAIAN.AN_PHASAN;
            DAL.DKK.DKKContextContainer dt = new DAL.DKK.DKKContextContainer();
            DAL.DKK.DONKK_DON obj = dt.DONKK_DON.Where(x => x.VUANID == IDVuViec
                                                         && x.MALOAIVUAN == MaLoaiVuAn).Single<DAL.DKK.DONKK_DON>();
            if (obj != null)
            {
                obj.VUANID = 0;
                obj.TRANGTHAI = 0;//da gui don nhung chua phan loai
                obj.MALOAIVUAN = MaLoaiVuAn;
                obj.NGAYSUA = DateTime.Now;
            }
            dt.SaveChanges();
        }


        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
        }

        protected void ddlCapXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAnXetXu();
            LoadDropThamphan();
            LoadDropThuKy();
        }

        protected void ddlToaAnXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDropThuKy();
            Load_Data();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                lbtXoa.Visible = false;
                decimal id_toaan = 0;
                if (ddlToaAnXetXu.SelectedValue != "")
                    id_toaan = Convert.ToDecimal(ddlToaAnXetXu.SelectedValue);
                decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                HiddenField hddMAGIAIDOAN = (HiddenField)e.Item.FindControl("hddMAGIAIDOAN");
                HiddenField hddCHECK_THULY = (HiddenField)e.Item.FindControl("hddCHECK_THULY");
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataRowView dv = (DataRowView)e.Item.DataItem;
                decimal VuAnID = Convert.ToDecimal(dv["ID"] + "");
                if (hddMAGIAIDOAN != null && hddMAGIAIDOAN.Value == ENUM_GIAIDOANVUAN.SOTHAM.ToString() || Session[ENUM_SESSION.SESSION_NHOMNSDID]+""=="1")
                {
                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                }
                if (hddCHECK_THULY.Value == "" || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")//Session[ENUM_SESSION.SESSION_NHOMNSDID]+""=="1" // nhóm Quản trị hệ thống 
                {
                    if (dv["MAGIAIDOAN"].ToString() == "3") //chuyen phúc thẩm khong duoc xoa
                    {

                        if (dv["HINHTHUCNHANDON"].ToString() != "998")  // Thu ly lai do GDT hủy để xét xử lại phúc thẩm
                            lbtXoa.Visible = false;
                        else
                            Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                    }
                    else
                    {
                        //Kiem tra da xu ly don chua, neu chua xu ly thi cho xoa
                        if (VuAnID > 0)
                        {
                            List<APS_DON_XULY> oDON_XLY = dt.APS_DON_XULY.Where(x => x.DONID == VuAnID).ToList<APS_DON_XULY>();
                            //phải là admin hoặc là nguoi tao thi mới duoc xoa
                            if ((dv["NGUOITAO"].ToString().ToLower() == strUserName.ToLower() || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1" || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "541")
                                 && LoginDonViID == id_toaan && oDON_XLY.Count == 0)
                                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                     
                             else
                                lbtXoa.Visible = false;
                            APS_DON_XULY oDXL_TL = dt.APS_DON_XULY.Where(x => (x.DONID == VuAnID || x.DON_XULYID == VuAnID) && x.LOAIGIAIQUYET != 3).FirstOrDefault();
                            if (oDON_XLY.Count > 0 && oDXL_TL == null)
                            {
                                e.Item.Cells[5].Text = "- Trả lại đơn";
                            }
                            var chuyenAn = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == id_toaan).FirstOrDefault();
                            APS_DON_XULY oDXL_CD = dt.APS_DON_XULY.Where(x => (x.DONID == VuAnID || x.DON_XULYID == VuAnID) && x.LOAIGIAIQUYET != 1).FirstOrDefault();
                            if (oDON_XLY.Count > 0 && oDXL_CD == null)
                            {
                                if (chuyenAn == null)
                                    e.Item.Cells[5].Text = "- Chờ chuyển đơn";
                                else
                                    e.Item.Cells[5].Text = "- Đã chuyển đơn";
                            }
                        }
                    }
                }
                else if (hddCHECK_THULY.Value != "")
                {
                    if ((Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1") && LoginDonViID == id_toaan)
                    {
                        lbtXoa.Visible = true;
                    }
                    else
                    {
                        lbtXoa.Visible = false;
                    }
                }
                string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                lblSua.Visible = true;
                if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    lblSua.Visible = false;
                }
                if (Result != "")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                Button cmdxxlaiPT = (Button)e.Item.FindControl("cmdxxlaiPT");
                if (dv["THULYXXLAI"].ToString() == "3") //Da co BA,QD giai doan phúc thẩm moi duoc Thu Ly Xet Xu Lai
                    cmdxxlaiPT.Visible = true;
                else
                    cmdxxlaiPT.Visible = false;

                CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                if (dv["MAGIAIDOAN"].ToString() == "2")
                {
                    APS_SOTHAM_BANAN obj = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == VuAnID).FirstOrDefault();
                    var objQD = (from a in dt.APS_SOTHAM_QUYETDINH
                                 join d in dt.DM_QD_QUYETDINH on a.QUYETDINHID equals d.ID
                                 join c in dt.DM_QD_LOAI on d.LOAIID equals c.ID
                                 where a.DONID == VuAnID && (c.MA == "DC" || c.MA == "CVA" || c.MA == "CNTT")
                                 select new { a.ID, }).FirstOrDefault();
                    if (obj != null || objQD != null)
                    {
                        chkChon.Visible = false;
                    }
                }
                else if (dv["MAGIAIDOAN"].ToString() == "3")
                {
                    APS_DON oDon = dt.APS_DON.Where(x => x.ID == VuAnID).FirstOrDefault();
                    if (oDon.TOAPHUCTHAMID == LoginDonViID)
                    {
                        APS_PHUCTHAM_BANAN obj = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == VuAnID).FirstOrDefault();
                        var objQD = (from a in dt.APS_PHUCTHAM_QUYETDINH
                                     join d in dt.DM_QD_QUYETDINH on a.QUYETDINHID equals d.ID
                                     join c in dt.DM_QD_LOAI on d.LOAIID equals c.ID
                                     where a.DONID == VuAnID && c.MA == "DC"
                                     select new { a.ID, }).FirstOrDefault();
                        if (obj != null || objQD != null)
                        {
                            chkChon.Visible = false;
                        }
                    }
                    else chkChon.Visible = false;
                }
            }
        }

        //Khai them
        protected void cmdTachan_Click(object sender, EventArgs e)
        {
            decimal vuAnGocId = 0, count = 0;
            APS_SOTHAM_THULY oNSD = new APS_SOTHAM_THULY();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    count++;
                    vuAnGocId = Convert.ToDecimal(Item.Cells[0].Text);
                    oNSD = dt.APS_SOTHAM_THULY.Where(x => x.DONID == vuAnGocId).FirstOrDefault();
                }
            }
            if (vuAnGocId == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn vụ án!";
                return;
            }
            else if (count > 1)
            {
                lbtthongbao.Text = "Bạn chỉ chọn một vụ án!";
                return;
            }
            //else if (count == 1 && oNSD == null)
            //{
            //    lbtthongbao.Text = "Vụ án chưa được thụ lý!";
            //    return;
            //}
            else
            {
                string link = "/QLAN/APS/Hoso/Popup/pTachAn.aspx?DonID=" + vuAnGocId;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv()");
            }
        }

        protected void cmdNhapan_Click(object sender, EventArgs e)
        {
            decimal vuAnGocId = 0, count = 0;
            APS_SOTHAM_THULY oNSD = new APS_SOTHAM_THULY();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    count++;
                    vuAnGocId = Convert.ToDecimal(Item.Cells[0].Text);
                    oNSD = dt.APS_SOTHAM_THULY.Where(x => x.DONID == vuAnGocId).FirstOrDefault();
                }
            }
            if (vuAnGocId == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn vụ án!";
                return;
            }
            else if (count > 1)
            {
                lbtthongbao.Text = "Bạn chỉ chọn một vụ án!";
                return;
            }
            //else if (count == 1 && oNSD == null)
            //{
            //    lbtthongbao.Text = "Vụ án chưa được thụ lý!";
            //    return;
            //}
            else
            {
                string link = "/QLAN/APS/Hoso/Popup/pNhapAn.aspx?DonID=" + vuAnGocId;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv()");
            }
        }

        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
            }
        }

        protected void chkNhapTach_CheckedChanged(object sender, EventArgs e)
        {
            if (chkNhapTach.Checked)
            {
                dgList.Columns[2].Visible = true;
                cmdNhapan.Visible = true;
                cmdTachan.Visible = true;
            }
            else
            {
                dgList.Columns[2].Visible = false;
                cmdNhapan.Visible = false;
                cmdTachan.Visible = false;
            }
        }

        //protected void cmdLoadNhapAn_Click(object sender, EventArgs e)
        //{
        //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Nhập vụ việc thành công!');", true);
        //    Load_Data();
        //}

        //protected void cmdLoadTachAn_Click(object sender, EventArgs e)
        //{
        //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Tách vụ việc thành công!');", true);
        //    Load_Data();
        //}
        protected void ck_GQTDC_QDK_CheckedChanged(object sender, EventArgs e)
        {
            if (Session["CAP_XET_XU"] + "" == "CAPTINH" && ck_GQTDC_QDK.Checked)
            {
                ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
            }
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #region Danh sách án phí
        protected void lbtDanhSachAnPhi_Click(object sender, EventArgs e)
        {
            string StrMsg = "PopupCenter('/QLAN/pDanhSachAnPhi.aspx?hsID=" + ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN.ToString() + "');";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

            //Response.Redirect("CapnhatKetqua.aspx?hsID=" + ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.ToString());
        }
        #endregion
    }
}