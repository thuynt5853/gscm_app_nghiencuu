using BL.GSTP;

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
using System.Web.Script.Serialization;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.XLHC.Hoso
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
                }
                LoadCombobox();
                //Load_Data();
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

        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_DENGHI_XLHC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            ddlQuanhephapluat.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            //--------------------

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
            LoadDropToaAnGiaiQuyet();
            LoadDropThuKy();
            LoadDropThamphan();
        }

        private void LoadDropToaAnGiaiQuyet()
        {
            ddlToaXetXu.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            if (ck_ANKETTHUC.Checked == false)
            {
                ddlToaXetXu.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", ddlCapXetXu.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
                ddlToaXetXu.DataTextField = "arrTEN";
                ddlToaXetXu.DataValueField = "ID";
                ddlToaXetXu.DataBind();
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
                {
                    ddlToaXetXu.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
                }
            }
            else
            {

                decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                DataTable dtSapNhap = bl.GETS_BY_TOAANTID(donviID);

                if (dtSapNhap != null)
                {
                    DataTable toaGoc = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", ddlCapXetXu.SelectedValue, donviID + "", Session["CAP_XET_XU"] + "");
                    if (toaGoc != null)
                    {
                        for (int j = 0; j < toaGoc.Rows.Count; j++)
                        {
                            ddlToaXetXu.Items.Add(new ListItem(toaGoc.Rows[j]["arrTEN"].ToString(), toaGoc.Rows[j]["ID"].ToString()));
                            //DropToaAn.Items.Insert(0, new ListItem(toaCon.Rows[i]["arrTEN"].ToString(), toaCon.Rows[i]["ID"].ToString()));
                        }

                    }

                    for (int i = 0; i < dtSapNhap.Rows.Count; i++)
                    {
                        if (ddlCapXetXu.SelectedValue == ENUM_GIAIDOANVUAN.PHUCTHAM.ToString())
                        {
                            DataTable toaCon;
                            if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == donviID)
                            {
                                toaCon = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", ddlCapXetXu.SelectedValue, dtSapNhap.Rows[i]["TOTOAANID"].ToString() + "", Session["CAP_XET_XU"] + "");
                                //DropToaAn.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                            }

                            else
                            {
                                toaCon = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", ddlCapXetXu.SelectedValue, dtSapNhap.Rows[i]["TOAANID"].ToString() + "", Session["CAP_XET_XU"] + "");
                                //DropToaAn.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                            }


                            if (toaCon != null)
                            {
                                for (int j = 0; j < toaCon.Rows.Count; j++)
                                {
                                    ddlToaXetXu.Items.Add(new ListItem(toaCon.Rows[j]["arrTEN"].ToString(), toaCon.Rows[j]["ID"].ToString()));
                                    //DropToaAn.Items.Insert(0, new ListItem(toaCon.Rows[i]["arrTEN"].ToString(), toaCon.Rows[i]["ID"].ToString()));
                                }

                            }
                        }
                        else
                        {
                            if (dtSapNhap.Rows[i]["HIEULUC"].ToString() == "1")
                                if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == donviID)
                                    ddlToaXetXu.Items.Add(new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                                else
                                    ddlToaXetXu.Items.Add(new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                        }

                    }

                }
            }
            LoadDropThamphan();
            LoadDropThuKy();
        }
        protected void LoadDropThuKy()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (ddlToaXetXu.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(ddlToaXetXu.SelectedValue, null);
            ddlThuKy.DataSource = tbl;
            ddlThuKy.DataTextField = "MA_TEN";
            ddlThuKy.DataValueField = "ID";
            ddlThuKy.DataBind();
            ddlThuKy.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        void LoadDropThamphan()
        {
            Boolean IsLoadAll = true;
            ddlThamPhan.Items.Clear();
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
                        ddlThamPhan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
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
                //decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal LoginDonViID = 0;
                if (ddlToaXetXu.SelectedValue != "")
                {
                    LoginDonViID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                }
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamPhan.DataSource = tbl;
                ddlThamPhan.DataTextField = "HOTEN";
                ddlThamPhan.DataValueField = "ID";
                ddlThamPhan.DataBind();
                ddlThamPhan.Items.Insert(0, new ListItem("-- Tất cả --", ""));

            }
            loadDropVaiTroThamPhan();
        }

        void loadDropVaiTroThamPhan()
        {
            //ddlVaiTroThamPhan.Items.Clear();
            //// Tìm kiếm theo sơ thẩm 
            //ddlVaiTroThamPhan.Items.Add(new ListItem("-- Tất cả --", ""));
            //ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết sơ thẩm", ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM));
            //ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán xử lý hồ sơ", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETDON));
            //ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
            //ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ toạ", ENUM_VAITROTHAMPHAN.VTTP_CHUTOASOTHAM)); 
            //ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
            //// Tìm kiếm theo phúc thẩm 
            //ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết phúc thẩm", ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM));

            ddlVaiTroThamPhan.Items.Clear();
            ddlVaiTroThamPhan.Items.Add(new ListItem("-- Tất cả --", ""));

            string capXetXu = ddlCapXetXu.SelectedValue;

            // Nếu người dùng chọn Sơ thẩm
            if (capXetXu == ENUM_GIAIDOANVUAN.SOTHAM.ToString())
            {
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết sơ thẩm", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETSOTHAM));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán xử lý hồ sơ", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETDON));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ toạ ", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
            }
            // Nếu người dùng chọn Phúc thẩm
            else if (capXetXu == ENUM_GIAIDOANVUAN.PHUCTHAM.ToString())
            {
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết phúc thẩm", ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ toạ ", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
            }
            // Nếu chưa chọn gì hoặc ở cấp Tỉnh (load cả hai loại)
            else
            {
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết phúc thẩm", ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ toạ", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
                ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
            }

        }
      
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlThamPhan.SelectedValue == null || ddlThamPhan.SelectedValue == "")
                ddlVaiTroThamPhan.SelectedValue = String.Empty;
        }
        protected void ck_ANKETTHUC_CheckedChanged(object sender, EventArgs e)
        {
            LoadDropToaAnGiaiQuyet();
        }
        private void Load_Data()
        {
            XLHC_DON_BL oBL = new XLHC_DON_BL();
            /*decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                    ThamPhanId = Convert.ToDecimal(ddlThamphan.SelectedValue),
                    LoaiQuanHe = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue),
                    QHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue),
                    GiaiDoan = Convert.ToDecimal(ddlGiaiDoan.SelectedValue),
                    HinhThucNhanDon = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue),
                    dSothutu = txtSothutu.Text.Trim() == "" ? 0 : Convert.ToDecimal(txtSothutu.Text.Trim()),
                    PhanCongTP = Convert.ToDecimal(ddlPhanCongTP.SelectedValue);
            DateTime? dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault),
                      dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            string MaVuViec = txtMaVuViec.Text.Trim(),
                   TenVuViec = txtTenVuViec.Text.Trim(),
                   Tenduongsu = txtTenduongsu.Text.Trim();*/

            //duongph 25/03/2022
            string vDonViID = Convert.ToString(Session[ENUM_SESSION.SESSION_DONVIID]),
                    vTenViec = txtTenViec.Text.Trim(),
                    vQuanHePhapLuat = ddlQuanhephapluat.SelectedValue,
                    vMaViec = txtMaViec.Text.Trim(),
                    vDoiTuongApDungBPXLHC = txtDoiTuongApDungBPXLHC.Text.Trim(),
                    vCapXetXu = ddlCapXetXu.SelectedValue,
                    vToaXetXu = ddlToaXetXu.SelectedValue,
                    vTinhTrangThuLy = ddlTinhTrangThuLy.SelectedValue,
                    vTuNgayThuLy = txtTuNgayThuLy.Text.Trim(),
                    vDenNgayThuLy = txtDenNgayThuLy.Text.Trim(),
                    vSoThuLy = txtSoThuLy.Text.Trim(),
                    vTinhTrangGQ = ddlTinhTrangGQ.SelectedValue,
                    vTuNgayGQ = txtTuNgayGQ.Text.Trim(),
                    vDenNgayGQ = txtDenNgayGQ.Text.Trim(),
                    vThamPhan = ddlThamPhan.SelectedValue,
                    vVaiTroThamPhan = ddlVaiTroThamPhan.SelectedValue,
                    vThoiHanGQ = ddlThoiHanGQ.SelectedValue,
                    vSoQD = txtSoQD.Text.Trim(),
                    vNgayQD = txtNgayQD.Text.Trim(),
                    vThuKy = ddlThuKy.SelectedValue,
                    vPTRutKinhNghiem = ddlPTRutKinhNghiem.SelectedValue;
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
            int count = oCBDT.Rows.Count;
            decimal ThuKyID = 0;
            if (count > 0)
            {
                ThuKyID = Convert.ToDecimal(oCBDT.Rows[0]["ID"]);
            }
            DataTable oDT = oBL.XLHC_DON_SEARCH(vDonViID, vTenViec, vQuanHePhapLuat, vMaViec, vDoiTuongApDungBPXLHC, vCapXetXu, vToaXetXu, vTinhTrangThuLy, vTuNgayThuLy, vDenNgayThuLy, vSoThuLy, vTinhTrangGQ, vTuNgayGQ, vDenNgayGQ, vThamPhan, vVaiTroThamPhan, vThoiHanGQ, vSoQD, vNgayQD, vThuKy, vPTRutKinhNghiem, ck_GQTDC_QDK.Checked == true ? 1 : 0, ck_ANKETTHUC.Checked == true ? 1 : 0, pageindex, page_size);

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
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            //try
            //{
                txtTenViec.Text = string.Empty;
                ddlQuanhephapluat.SelectedIndex = 0;
                txtMaViec.Text = string.Empty;
                txtDoiTuongApDungBPXLHC.Text = string.Empty;
                ddlCapXetXu.SelectedIndex = 0;
                ddlToaXetXu.SelectedIndex = 0;
                ddlTinhTrangThuLy.SelectedIndex = 0;
                txtTuNgayThuLy.Text = string.Empty;
                txtDenNgayThuLy.Text = string.Empty;
                txtSoThuLy.Text = string.Empty;
                ddlTinhTrangGQ.SelectedIndex = 0;
                txtTuNgayGQ.Text = string.Empty;
                txtDenNgayGQ.Text = string.Empty;
                ddlThamPhan.SelectedIndex = 0;
                ddlThoiHanGQ.SelectedIndex = 0;
                txtSoQD.Text = string.Empty;
                txtNgayQD.Text = string.Empty;
                ddlThuKy.SelectedIndex = 0;
                ddlPTRutKinhNghiem.SelectedIndex = 0;
                ddlVaiTroThamPhan.SelectedIndex = 0;
            //} 
            //catch (Exception ex)
            //{

            //}
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            //---huy vu an da ghim
            Decimal IDVuViec = 0;
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
            oNSD.IDBPXLHC = IDVuViec;
            dt.SaveChanges();
            Session[ENUM_LOAIAN.BPXLHC] = IDVuViec;
            //-----------------------
            Session["XLHC_THEMDSK"] = null;
            Response.Redirect("Thongtindon.aspx?type=new");

        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            decimal IDVuViec = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Select"://Lựa chọn vụ việc cần Lưu thông tin
                    //Lưu vào người dùng
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                    {
                        oNSD.IDBPXLHC = IDVuViec;
                        dt.SaveChanges();
                    }
                    Session[ENUM_LOAIAN.BPXLHC] = IDVuViec;

                    //lưu seccsion thông tin kết thúc vụ án
                    decimal Donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    var gd = DataExtensions.GetAllByDonId("XLHC_DON_GIAIDOAN",IDVuViec).ToList();
                    Session[ENUM_LOAIAN.AN_DA_KET_THUC] = false;
                    if (gd.Count == 1)
                    {
                        if (gd[0].AN_DA_KET_THUC != null && gd[0].AN_DA_KET_THUC == 1)
                        {
                            Session[ENUM_LOAIAN.AN_DA_KET_THUC] = true;
                        }
                    }
                    if (gd.Count > 1)
                    {
                        var x = gd.FirstOrDefault(c => c.TOAPHUCTHAMID == Donvi_ID && c.MAGIAIDOAN != ENUM_GIAIDOANVUAN.SOTHAM);
                        if (x != null)
                        {
                            if (x.AN_DA_KET_THUC != null && x.AN_DA_KET_THUC == 1)
                            {
                                Session[ENUM_LOAIAN.AN_DA_KET_THUC] = true;
                            }
                        }
                        else
                        {
                            var y = gd.FirstOrDefault(c => c.TOAPHUCTHAMID == null && c.MAGIAIDOAN != ENUM_GIAIDOANVUAN.SOTHAM);
                            if (y != null)
                            {
                                if (y.AN_DA_KET_THUC != null && y.AN_DA_KET_THUC == 1)
                                {
                                    Session[ENUM_LOAIAN.AN_DA_KET_THUC] = true;
                                }
                            }
                        }
                    }

                    XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
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
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }

                    XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    var json = new JavaScriptSerializer().Serialize(oT);


                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                    {
                        ADS_DON_BL oBL1 = new ADS_DON_BL();
                        //Luu thong tin ho so vu an khi xoa
                        if (oBL1.HISTORY_ALLDATA_BY_VUANID(IDVuViec, 8, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Danh sách án Xử lý hành chính", "Xóa", json) == false)
                        {
                            lbtthongbao.Text = "Lỗi khi lưu lịch sử khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                        else
                        {
                            lbtthongbao.Text = "Xóa thành công !";
                        }

                        XLHC_DON_BL oBL = new XLHC_DON_BL();
                        if (oBL.DELETE_ALLDATA_BY_VUANID(IDVuViec + "") == false)
                        {
                            lbtthongbao.Text = "Lỗi khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                    }
                    else
                    {
                        //Kiểm tra nếu đã có ràng buộc không cho phép xóa
                        //if (dt.XLHC_DUONGSU.Where(x => x.DONID == IDVuViec).ToList().Count > 0)
                        //{
                        //    lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
                        //    return;
                        //}
                        if (oT != null)
                        {
                            int GiaiDoan = (int)oT.MAGIAIDOAN;
                            if (GiaiDoan == ENUM_GIAIDOANVUAN.HOSO)
                            {
                                #region Kiểm tra dữ liệu liên quan
                                // Kiểm tra giải quyết hồ sơ
                                XLHC_DON_XULY anphi = dt.XLHC_DON_XULY.Where(x => x.DONID == IDVuViec).FirstOrDefault<XLHC_DON_XULY>();
                                if (anphi != null)
                                {
                                    lbtthongbao.Text = "Vụ việc đã có dữ liệu giải quyết hồ sơ, không được phép xóa!";
                                    return;
                                }
                                // Kiểm tra thẩm phán giải quyết hồ sơ
                                XLHC_DON_THAMPHAN xld = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == IDVuViec).FirstOrDefault<XLHC_DON_THAMPHAN>();
                                if (xld != null)
                                {
                                    lbtthongbao.Text = "Vụ việc đã có dữ liệu thẩm phán giải quyết hồ sơ, không được phép xóa!";
                                    return;
                                }
                                // Kiểm tra người tham gia tố tụng
                                XLHC_DON_THAMGIATOTUNG tgtt = dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.DONID == IDVuViec).FirstOrDefault<XLHC_DON_THAMGIATOTUNG>();
                                if (tgtt != null)
                                {
                                    lbtthongbao.Text = "Vụ việc đã có dữ liệu người tham gia tố tụng, không được phép xóa!";
                                    return;
                                }
                                // Kiểm tra Giao nhận tài liệu chứng cứ
                                XLHC_DON_TAILIEU tailieu = dt.XLHC_DON_TAILIEU.Where(x => x.DONID == IDVuViec).FirstOrDefault<XLHC_DON_TAILIEU>();
                                if (tailieu != null)
                                {
                                    lbtthongbao.Text = "Vụ việc đã có dữ liệu giao nhận tài liệu chứng cứ, không được phép xóa!";
                                    return;
                                }

                                var delete_all_record_XLHC_DUONGSU_by_donid = dt.XLHC_DUONGSU.Where(x => x.DONID == IDVuViec);
                                dt.XLHC_DUONGSU.RemoveRange(delete_all_record_XLHC_DUONGSU_by_donid);

                                #endregion
                                dt.XLHC_DON.Remove(oT);
                                dt.SaveChanges();
                            }
                        }
                    }
                    decimal IDVuViec_ = Convert.ToDecimal(e.CommandArgument.ToString());
                    decimal IDUser_ = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    //để sửa lỗi mất menu khi xóa vụ án, anhvh add trường hợp xóa vụ án và uppdate lại idvuan =0 để giải phóng việc gim vụ án
                    QT_NGUOISUDUNG oNSD_ = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser_).FirstOrDefault();
                    if (oNSD_.IDBPXLHC == IDVuViec_)
                    {
                        oNSD_.IDBPXLHC = 0;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }


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

        protected void ddlToaGiaiQuyet_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDropThuKy();
            Load_Data();
        }

        protected void ddlCapXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAnGiaiQuyet();
            LoadDropThamphan();
            LoadDropThuKy();
            loadDropVaiTroThamPhan();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                DataRowView dv = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                HiddenField hddMAGIAIDOAN = (HiddenField)e.Item.FindControl("hddMAGIAIDOAN");
                HiddenField hddCHECK_THULY = (HiddenField)e.Item.FindControl("hddCHECK_THULY");
                if (hddMAGIAIDOAN != null && hddMAGIAIDOAN.Value == "1")
                {
                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                }
                else
                {
                    lbtXoa.Visible = false;
                }

                decimal VuAnID = Convert.ToDecimal(dv["ID"] + "");
                if (hddCHECK_THULY.Value == "")
                {
                    if (dv["MAGIAIDOAN"].ToString() == "3") //phúc thẩm
                    {
                        if (dv["HINHTHUCNHANDON"].ToString() != "998")  // Thu ly lai do GDT hủy để xét xử lại phúc thẩm
                            lbtXoa.Visible = false;
                        else
                            Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                    }
                    else
                    {
                        Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                        List<XLHC_DON_XULY> oDON_XLY = dt.XLHC_DON_XULY.Where(x => (x.DONID == VuAnID)).ToList<XLHC_DON_XULY>();
                        XLHC_DON_XULY oDXL_TL = dt.XLHC_DON_XULY.Where(x => (x.DONID == VuAnID) && x.LOAIGIAIQUYET != 3).FirstOrDefault();
                        if (oDON_XLY.Count > 0 && oDXL_TL == null)
                        {
                            e.Item.Cells[4].Text = "- Trả lại hồ sơ";
                        }
                    }
                }
                else if (hddCHECK_THULY.Value != "")
                {
                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                    {
                        lbtXoa.Visible = true;
                    }
                    else
                    {
                        lbtXoa.Visible = false;
                    }
                }
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                {
                    lbtXoa.Visible = true;
                }
                
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "");
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
            }
        }

        protected void ck_GQTDC_QDK_CheckedChanged(object sender, EventArgs e)
        {
            if (Session["CAP_XET_XU"] + "" == "CAPTINH" && ck_GQTDC_QDK.Checked)
            {
                ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
            }
            hddPageIndex.Value = "1";
            Load_Data();
        }
    }
}