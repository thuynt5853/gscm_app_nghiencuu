using BL.GSTP;
using BL.GSTP.AHC;
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
using BL.GSTP.BANGSETGET.AHC;

namespace WEB.GSTP.QLAN.AHC.Hoso
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
            try
            {
                if (!IsPostBack)
                {
                    string strSearch = Session["textsearch"] + "";
                    LoadDrop_QHPL_TK();
                    if (strSearch != "")
                    {
                        txtTENDUONGSU.Text = strSearch;
                        Session["textsearch"] = "";
                        LoadDropToaAn();
                        LoadCombobox();
                        Load_Data();
                    }
                    else
                    {
                        //DropTINHTRANG_GIAIQUYET.SelectedValue = "1";
                        LoadDropToaAn();
                        LoadCombobox();
                    }

                    string isset = Session[TK_CANHBAO.TK_SET_DEFAULT_VALUE] + "";
                    if (isset == "1")
                    {
                        SetGetSessionTK(false);
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
            catch (Exception ex)
            {
                lbtthongbao.Text = "Lỗi xảy ra: " + ex;
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
            //        //    int countItem = dt.ADS_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == DonID);
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
        private void SetGetSessionTK(bool isSet)
        {
            if (!isSet)
            {                
                //Cần mở để khi nhấn link từ bảng thống kê trang chủ có thể set sẵn value
                DropTINHTRANG_GIAIQUYET.SelectedValue = Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] + "";
                DropTHOIHAN_GQ.SelectedValue = Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] + "";
                dropCapxx.SelectedValue = Session[TK_CANHBAO.CAPXX] + "";
                DropTINHTRANG_THULY.SelectedValue = Session[TK_CANHBAO.TINHTRANG_THULY] + "";
                txtTuNgay.Text = Session[TK_CANHBAO.TUNGAY] + "";
                drop_BIENPHAPGQ.SelectedValue = Session[TK_CANHBAO.GQDON] + "";
            }
        }
        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
            Session[TK_CANHBAO.GQDON] = "";
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            ClearSession_TK();
            txtTenVuViec.Text = string.Empty;
            txt_QHPL.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtTENDUONGSU.Text = string.Empty;
            dropCapxx.SelectedIndex = 0;
            DropTINHTRANG_THULY.SelectedValue = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSOTHULY_THONGBAO.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            Drop_KETQUA.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;
            DropTHOIHAN_GQ.SelectedValue = string.Empty;
            drop_BIENPHAPGQ.SelectedValue = string.Empty;
            dropUTTP.SelectedValue = string.Empty;
            Drop_PT_RKINHNGHIEM.SelectedValue = string.Empty;
            Drop_Loaidon.SelectedValue = string.Empty;
        }
        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            if (ck_ANKETTHUC.Checked == false)
            {

                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
                {
                    DropToaAn.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
                }
            }
            else
            {

                decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                DataTable dtSapNhap = bl.GETS_BY_TOAANTID(donviID);

                if (dtSapNhap != null)
                {
                    DataTable toaGoc = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, donviID + "", Session["CAP_XET_XU"] + "");
                    if (toaGoc != null)
                    {
                        for (int j = 0; j < toaGoc.Rows.Count; j++)
                        {
                            DropToaAn.Items.Add(new ListItem(toaGoc.Rows[j]["arrTEN"].ToString(), toaGoc.Rows[j]["ID"].ToString()));
                            //DropToaAn.Items.Insert(0, new ListItem(toaCon.Rows[i]["arrTEN"].ToString(), toaCon.Rows[i]["ID"].ToString()));
                        }

                    }

                    for (int i = 0; i < dtSapNhap.Rows.Count; i++)
                    {
                        if (dropCapxx.SelectedValue == ENUM_GIAIDOANVUAN.PHUCTHAM.ToString())
                        {
                            DataTable toaCon;
                            if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == donviID)
                            {
                                toaCon = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, dtSapNhap.Rows[i]["TOTOAANID"].ToString() + "", Session["CAP_XET_XU"] + "");
                                //DropToaAn.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                            }

                            else
                            {
                                toaCon = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, dtSapNhap.Rows[i]["TOAANID"].ToString() + "", Session["CAP_XET_XU"] + "");
                                //DropToaAn.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                            }


                            if (toaCon != null)
                            {
                                for (int j = 0; j < toaCon.Rows.Count; j++)
                                {
                                    DropToaAn.Items.Add(new ListItem(toaCon.Rows[j]["arrTEN"].ToString(), toaCon.Rows[j]["ID"].ToString()));
                                    //DropToaAn.Items.Insert(0, new ListItem(toaCon.Rows[i]["arrTEN"].ToString(), toaCon.Rows[i]["ID"].ToString()));
                                }

                            }
                        }
                        else
                        {
                            if (dtSapNhap.Rows[i]["HIEULUC"].ToString() == "1")
                                if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == donviID)
                                    DropToaAn.Items.Add(new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                                else
                                    DropToaAn.Items.Add(new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                        }

                    }

                }
            }
        }
        protected void ck_ANKETTHUC_CheckedChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
        }
        void LoadCombobox()
        {
            //--------------------
            dropCapxx.Items.Clear();
            //edit by anhvh 21/02/2020
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ck_GQTDC_QDK.Enabled = false;
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                dropCapxx.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------
            LoadDropThamphan();
            LoadDrop_TTV_TK();
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
                if (DropToaAn.SelectedValue != "")
                {
                    LoginDonViID = Convert.ToDecimal(DropToaAn.SelectedValue);
                }
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
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán phụ trách hòa giải/đối thoại", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_HOAGIAI));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết đơn", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETDON));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết vụ việc", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETVUVIEC));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
        }
        protected void LoadDrop_QHPL_TK()
        {
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng cho thống kê--", "0"));
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlThamphan.SelectedValue == null || ddlThamphan.SelectedValue == "")
                ddlVaiTroThamPhan.SelectedValue = String.Empty;
            ddlVaiTroThamPhan_SelectedIndexChanged(new object(), new EventArgs());
        }
        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropCapxx.SelectedValue != ENUM_GIAIDOANVUAN.PHUCTHAM.ToString())
            {
                ck_GQTDC_QDK.Checked = false;
            }
            LoadDropToaAn();
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            // Load_Data();
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            Load_Data();
        }
        protected void LoadDrop_TTV_TK()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (DropToaAn.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(DropToaAn.SelectedValue, null);
            ddlHTND_Thuky.DataSource = tbl;
            ddlHTND_Thuky.DataTextField = "MA_TEN";
            ddlHTND_Thuky.DataValueField = "ID";
            ddlHTND_Thuky.DataBind();
            ddlHTND_Thuky.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        private void Load_Data()
        {
            try
            {
                decimal vchecktk = 0;
                CheckChucDanhUser(ref vchecktk);
                AHC_DON_BL oBL = new AHC_DON_BL();
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                    pageindex = Convert.ToInt32(hddPageIndex.Value),
                    count_all = 0,
                trangThaiVuAn = Convert.ToInt32(ddlTrangThaiVuAn.SelectedValue);
                DataTable oDT = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), txtMaVuViec.Text.Trim(), txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                DropTINHTRANG_THULY.SelectedValue, txtSOTHULY_THONGBAO.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, ddlThamphan.SelectedValue, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                                txt_NgayQD.Text.Trim(), ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, Drop_Loaidon.SelectedValue, Drop_PT_RKINHNGHIEM.SelectedValue, drop_BIENPHAPGQ.SelectedValue, dropUTTP.SelectedValue, vchecktk, trangThaiVuAn, ck_GQTDC_QDK.Checked == true ? 1 : 0, ddlVaiTroThamPhan.SelectedValue,
                                                Convert.ToDecimal(ddlSoTL_TB.SelectedValue), Convert.ToDecimal(DropMA_THONG_BAO.SelectedValue), ck_ANKETTHUC.Checked == true ? 1 : 0, pageindex, page_size,
                checkHG.Checked == true ? 1 : 0,
                checkHG.Checked == true ? Convert.ToDecimal(ddlHoaGiaiKQ.SelectedValue) : 0,
                checkHG.Checked == true ? txtHoaGiaiTuNgay.Text.Trim() : "",
                checkHG.Checked == true ? txtHoaGiaiDenNgay.Text.Trim() : "", ddlQHPLTK.SelectedValue);
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
            catch (Exception ex)
            {
                lbtthongbao.Text = "Lỗi xảy ra: " + ex;
            }
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
                ADS_DON_BL oBL = new ADS_DON_BL();
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                    pageindex = Convert.ToInt32(hddPageIndex.Value),
                    count_all = 0;
                DataTable oDT = oBL.DON_NHAPTACH_SEARCH(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), txtMaVuViec.Text.Trim(), txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                DropTINHTRANG_THULY.SelectedValue, txtSOTHULY_THONGBAO.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue, Drop_Loaidon.SelectedValue, status, 6, pageindex, page_size);

                if (oDT != null && oDT.Rows.Count > 0)
                {
                    foreach (DataRow item in oDT.Rows)
                    {
                        decimal donConID = Convert.ToDecimal(item["ID"].ToString());
                        DON_NHAPTACH dNT = dt.DON_NHAPTACH.Where(x => x.ID == donConID).FirstOrDefault();
                        if (dNT != null && status == 1)
                        {
                            AHC_DON dGoc = dt.AHC_DON.Where(x => x.ID == dNT.VUANGOCID).FirstOrDefault();
                            string tempGQ = item["TINHTRANG_GQ"].ToString();
                            if (dGoc != null && status == 1)
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
            oNSD.IDANHANHCHINH = IDVuViec;
            dt.SaveChanges();
            Session[ENUM_LOAIAN.AN_HANHCHINH] = IDVuViec;
            //-----------------------
            Session["HC_THEMDSK"] = null;
            Response.Redirect("Thongtindon.aspx?type=new");
        }
        // VNPT HOANGNDH 06/01/2026 16:00:00
        // hàm xóa đơn GĐT hủy xét xử lại sơ thẩm
        void Xoa_An_XxlaiST(MenuPermission oPer, decimal IDVuViec)
        {
            if (oPer.XOA == false)
            {
                lbtthongbao.Text = "Bạn không có quyền xóa!";
                return;
            }
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
            AHC_SOTHAM_THULY oT_TL = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();

            if (oT != null)
            {

                if (oT_TL == null)//chưa thụ lý
                {
                    // xóa màn án phí
                    List<AHC_ANPHI> lstAP = dt.AHC_ANPHI.Where(x => x.DONID == IDVuViec).ToList<AHC_ANPHI>();
                    if (lstAP.Count > 0)
                    {
                        foreach (AHC_ANPHI ap in lstAP)
                        {
                            dt.AHC_ANPHI.Remove(ap);
                        }
                        dt.SaveChanges();
                    }

                    // xóa màn tài liệu
                    List<AHC_DON_TAILIEU> lstTL = dt.AHC_DON_TAILIEU.Where(x => x.DONID == IDVuViec).ToList<AHC_DON_TAILIEU>();
                    if (lstTL.Count > 0)
                    {
                        foreach (AHC_DON_TAILIEU tl in lstTL)
                        {
                            dt.AHC_DON_TAILIEU.Remove(tl);
                        }
                        dt.SaveChanges();
                    }

                    // xóa màn người tham gia tố tụng khác
                    List<AHC_DON_THAMGIATOTUNG> lstTGTT = dt.AHC_DON_THAMGIATOTUNG.Where(x => x.DONID == IDVuViec).ToList<AHC_DON_THAMGIATOTUNG>();
                    if (lstTL.Count > 0)
                    {
                        foreach (AHC_DON_THAMGIATOTUNG tgtt in lstTGTT)
                        {
                            dt.AHC_DON_THAMGIATOTUNG.Remove(tgtt);
                        }
                        dt.SaveChanges();
                    }

                    // xóa màn đơn khác
                    List<DON_KHAC> lstDK = dt.DON_KHAC.Where(x => x.DONID == IDVuViec && x.LOAIANID == 6).ToList<DON_KHAC>();
                    if (lstDK.Count > 0)
                    {
                        foreach (DON_KHAC dk in lstDK)
                        {
                            dt.DON_KHAC.Remove(dk);
                        }
                        dt.SaveChanges();
                    }
                    // xóa màn đơn thẩm phán
                    List<AHC_DON_THAMPHAN> lstTP = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == IDVuViec).ToList<AHC_DON_THAMPHAN>();
                    if (lstTP.Count > 0)
                    {
                        foreach (AHC_DON_THAMPHAN tp in lstTP)
                        {
                            dt.AHC_DON_THAMPHAN.Remove(tp);
                        }
                        dt.SaveChanges();
                    }
                    // xóa đơn xử lý
                    List<AHC_DON_XULY> lstDonXL = dt.AHC_DON_XULY.Where(x => x.DONID == IDVuViec).ToList<AHC_DON_XULY>();
                    if (lstTP.Count > 0)
                    {
                        foreach (AHC_DON_XULY xuLy in lstDonXL)
                        {
                            dt.AHC_DON_XULY.Remove(xuLy);
                        }
                        dt.SaveChanges();
                    }


                    List<AHC_FILE> lstF = dt.AHC_FILE.Where(x => x.DONID == IDVuViec).ToList<AHC_FILE>();
                    if (lstF.Count > 0)
                    {
                        foreach (AHC_FILE f in lstF)
                        {
                            dt.AHC_FILE.Remove(f);
                        }
                        dt.SaveChanges();
                    }

                    var delete_all_record_AHC_DON_DUONGSU_by_donid = dt.AHC_DON_DUONGSU.Where(x => x.DONID == IDVuViec);
                    dt.AHC_DON_DUONGSU.RemoveRange(delete_all_record_AHC_DON_DUONGSU_by_donid);

                    dt.AHC_DON.Remove(oT);
                    dt.SaveChanges();

                    //K: Nếu vụ việc tồn tại trong bảng DON_TIEPNHAN thì cập nhật trạng thái DON_GUINHAN = 4
                    DON_TIEPNHAN dtn = dt.DON_TIEPNHAN.Where(x => x.DONID == IDVuViec && x.LOAIAN == 6).FirstOrDefault();
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
                    GD.GIAIDOAN_DELETES("6", IDVuViec, 2);
                    //---------------------------
                    if (oT.HINHTHUCNHANDON == 3)
                    {
                        //la don truc tuyen --> cho phep phan loai lai donkk
                        try { PhanLoaiLai_DonKK(oPer, IDVuViec); } catch { }
                    }
                }
            }
        }
        void Xoa_An(MenuPermission oPer, decimal IDVuViec)
        {
            if (oPer.XOA == false)
            {
                lbtthongbao.Text = "Bạn không có quyền xóa!";
                return;
            }
            //-------------------------------
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
            if (oT != null)
            {
                int GiaiDoan = (int)oT.MAGIAIDOAN;
                if (GiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    #region Kiểm tra dữ liệu liên quan
                    // Kiểm tra Án phí
                    AHC_ANPHI anphi = dt.AHC_ANPHI.Where(x => x.DONID == IDVuViec).FirstOrDefault<AHC_ANPHI>();
                    if (anphi != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu thông tin biên lai án phí, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra giải quyết đơn
                    AHC_DON_XULY xld = dt.AHC_DON_XULY.Where(x => x.DONID == IDVuViec).FirstOrDefault<AHC_DON_XULY>();
                    if (xld != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu giải quyết đơn, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra thẩm phán giải quyết đơn
                    AHC_DON_THAMPHAN gqd = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == IDVuViec && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault<AHC_DON_THAMPHAN>();
                    if (gqd != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu thẩm phán giải quyết đơn. Không được xóa.";
                        return;
                    }
                    // Kiểm tra Giao nhận tài liệu chứng cứ
                    AHC_DON_TAILIEU tailieu = dt.AHC_DON_TAILIEU.Where(x => x.DONID == IDVuViec).FirstOrDefault<AHC_DON_TAILIEU>();
                    if (tailieu != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu giao nhận tài liệu chứng cứ, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra người tham gia tố tụng khác
                    AHC_DON_THAMGIATOTUNG tgtt = dt.AHC_DON_THAMGIATOTUNG.Where(x => x.DONID == IDVuViec).FirstOrDefault<AHC_DON_THAMGIATOTUNG>();
                    if (tgtt != null)
                    {
                        lbtthongbao.Text = "Vụ việc đã có dữ liệu người tham gia tố tụng khác, không được phép xóa!";
                        return;
                    }
                    // Kiểm tra danh sách đương sự
                    //AHC_DON_DUONGSU ds = dt.AHC_DON_DUONGSU.Where(x => x.DONID == IDVuViec && x.ISDAIDIEN != 1).FirstOrDefault<AHC_DON_DUONGSU>();
                    //if (ds != null)
                    //{
                    //    lbtthongbao.Text = "Vụ việc đã có dữ liệu trong danh sách đương sự, không được phép xóa!";
                    //    return;
                    //}
                    //K: Nếu vụ việc đã có đơn con thì không cho xoá
                    DON_CHITIET dct = dt.DON_CHITIET.Where(x => x.DONID == IDVuViec && x.LOAIANID == 6).FirstOrDefault();
                    DON_KHAC dk = dt.DON_KHAC.Where(x => x.DONID == IDVuViec && x.LOAIANID == 6).FirstOrDefault();
                    if (dct != null && dk != null)
                    {
                        lbtthongbao.Text = "Vụ việc đang có đơn, không được xoá!";
                        return;
                    }
                    #endregion

                    List<AHC_FILE> lstF = dt.AHC_FILE.Where(x => x.DONID == IDVuViec).ToList<AHC_FILE>();
                    if (lstF.Count > 0)
                    {
                        foreach (AHC_FILE f in lstF)
                        {
                            dt.AHC_FILE.Remove(f);
                        }
                        dt.SaveChanges();
                    }

                    var delete_all_record_AHC_DON_DUONGSU_by_donid = dt.AHC_DON_DUONGSU.Where(x => x.DONID == IDVuViec);
                    dt.AHC_DON_DUONGSU.RemoveRange(delete_all_record_AHC_DON_DUONGSU_by_donid);

                    dt.AHC_DON.Remove(oT);
                    dt.SaveChanges();

                    //K: Nếu vụ việc tồn tại trong bảng DON_TIEPNHAN thì cập nhật trạng thái DON_GUINHAN = 4
                    DON_TIEPNHAN dtn = dt.DON_TIEPNHAN.Where(x => x.DONID == IDVuViec && x.LOAIAN == 6).FirstOrDefault();
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
                    GD.GIAIDOAN_DELETES("6", IDVuViec, 2);
                    //---------------------------
                    if (oT.HINHTHUCNHANDON == 3)
                    {
                        //la don truc tuyen --> cho phep phan loai lai donkk
                        try { PhanLoaiLai_DonKK(oPer, IDVuViec); } catch { }
                    }
                }
            }
        }
        void PhanLoaiLai_DonKK(MenuPermission oPer, decimal IDVuViec)
        {
            String MaLoaiVuAn = ENUM_LOAIAN.AN_HANHCHINH;
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
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            decimal id_toaan = 0;
            if (DropToaAn.SelectedValue != "")
                id_toaan = Convert.ToDecimal(DropToaAn.SelectedValue);
            DM_TOAAN ota = dt.DM_TOAAN.Where(x => x.ID == id_toaan).FirstOrDefault<DM_TOAAN>();
            decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //---------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                lbtXoa.Visible = false;
                HiddenField hddCHECK_THULY = (HiddenField)e.Item.FindControl("hddCHECK_THULY");
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                Button cmdChitiet = (Button)e.Item.FindControl("cmdChitiet");
                DataRowView dv = (DataRowView)e.Item.DataItem;
                decimal VuAnID = Convert.ToDecimal(dv["ID"] + "");
                if (hddCHECK_THULY.Value == "" || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
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
                        // VNPT HOANGNDH 06/01/2026 14:00:00
                        // cho phép xóa án tạo từ thụ lý lại do GĐT  hủy xét xử lại sơ thẩm
                        if (dv["HINHTHUCNHANDON"].ToString() == "2597" && hddCHECK_THULY.Value == "")  // Thu ly lai do GDT hủy để xét xử lại sơ thẩm
                            Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                        else
                        {
                            //Kiem tra da xu ly don chua, neu chua xu ly thi cho xoa
                            if (VuAnID > 0)
                            {
                                List<AHC_DON_XULY> oDON_XLY = dt.AHC_DON_XULY.Where(x => x.DONID == VuAnID).ToList<AHC_DON_XULY>();
                                //phải là admin hoặc là nguoi tao thi mới duoc xoa
                                if ((dv["NGUOITAO"].ToString().ToLower() == strUserName.ToLower() || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1" || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "541")
                                     && LoginDonViID == id_toaan && oDON_XLY.Count == 0)
                                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                                else
                                    lbtXoa.Visible = false;
                                AHC_DON_XULY oDXL_TL = dt.AHC_DON_XULY.Where(x => (x.DONID == VuAnID || x.DON_XULYID == VuAnID) && x.LOAIGIAIQUYET != 3).FirstOrDefault();
                                if (oDON_XLY.Count > 0 && oDXL_TL == null)
                                {
                                    e.Item.Cells[5].Text = "- Trả lại đơn";
                                }
                                var chuyenAn = dt.AHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == id_toaan).FirstOrDefault();
                                AHC_DON_XULY oDXL_CD = dt.AHC_DON_XULY.Where(x => (x.DONID == VuAnID || x.DON_XULYID == VuAnID) && x.LOAIGIAIQUYET != 1).FirstOrDefault();
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
                if (oPer.CAPNHAT == false && Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" != "1") //các trường hợp không phải admin mà là user admin nếu đã được phân quyền thì cũng như user admin
                {
                    lblSua.Visible = false;
                }
                else if (oPer.CAPNHAT == true || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                {
                    lblSua.Visible = true;
                    if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        lblSua.Visible = false;
                    }
                }
                cmdChitiet.Enabled = true;
                cmdChitiet.CssClass = "buttonchitiet";
                //if (Session["CAP_XET_XU"] + "" == "CAPTINH")
                //{
                //    if (ota.LOAITOA == "CAPHUYEN")
                //    {
                //        cmdChitiet.Enabled = false;//buttondisable
                //        cmdChitiet.CssClass = "buttondisable";
                //        lblSua.Visible = false;
                //        lbtXoa.Visible = false;
                //    }
                //}

                string Result = new AHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lblSua.Text = "Chi tiết";
                    if (dv["HINHTHUCNHANDON"].ToString() != "998")  // Thu ly lai do GDT hủy để xét xử lại phúc thẩm
                        lbtXoa.Visible = false;
                }
                Button cmdxxlaiPT = (Button)e.Item.FindControl("cmdxxlaiPT");
                //VNPT HOANGNDH Thêm thụ lý xét xử lại ST do GĐT hủy.
                Button cmdxxlaiST = (Button)e.Item.FindControl("cmdxxlaiST");
                if (dv["THULYXXLAI"].ToString() == "3") //Da co BA,QD giai doan phúc thẩm moi duoc Thu Ly Xet Xu Lai
                {
                    cmdxxlaiPT.Visible = true;
                    cmdxxlaiST.Visible = false;
                }
                else if (dv["THULYXXLAI"].ToString() == "4")
                {
                    cmdxxlaiST.Visible = true;
                    cmdxxlaiPT.Visible = false;
                }
                else
                {
                    cmdxxlaiST.Visible = false;
                    cmdxxlaiPT.Visible = false;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            decimal IDVuViec = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "xxlaiPT"://Tạo Ho so Xet xu lai Phuc Tham và lựa chọn vụ việc cần Lưu thông tin                  
                    createHoso_xetxulaiPhuctham(IDVuViec);
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "xxlaiST"://Tạo Ho so Xet xu lai So Tham và lựa chọn vụ việc cần Lưu thông tin                  
                    createHoso_xetxulaiSotham(IDVuViec);
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "Select"://Lựa chọn vụ việc cần Lưu thông tin                  
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                    {
                        oNSD.IDANHANHCHINH = IDVuViec;
                        dt.SaveChanges();
                    }
                    Session[ENUM_LOAIAN.AN_HANHCHINH] = IDVuViec;
                    //Thông báo nếu án đã được chuyển lên cấp trên
                    AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    //lưu seccsion thông tin kết thúc vụ án
                    decimal Donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    List<AHC_DON_GIAIDOAN> gd = dt.AHC_DON_GIAIDOAN.AsNoTracking().Where(x => x.DONID == IDVuViec).ToList();
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
                    if (oDon.TOAANID == oNSD.DONVIID && (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT))
                        Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Vụ việc đã được chuyển lên cấp trên, các thông tin sẽ không được phép thay đổi !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    else
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "Sua":
                    Response.Redirect("Thongtindon.aspx?type=list&ID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
                    AHC_DON oT = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    var json = new JavaScriptSerializer().Serialize(oT);

                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                    {
                        ADS_DON_BL oBL1 = new ADS_DON_BL();
                        //Luu thong tin ho so vu an khi xoa
                        if (oBL1.HISTORY_ALLDATA_BY_VUANID(IDVuViec, 6, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Danh sách án Hành chính", "Xóa", json) == false)
                        {
                            lbtthongbao.Text = "Lỗi khi lưu lịch sử khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                        else
                        {
                            lbtthongbao.Text = "Xóa thành công !";
                        }

                        AHC_DON_BL oBL = new AHC_DON_BL();
                        if (oBL.DELETE_ALLDATA_BY_VUANID(IDVuViec + "") == true)
                        {
                            //anhvh add 26/06/2020
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GIAIDOAN_DELETES("6", IDVuViec, 2);
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
                        // VNPT HOANGNDH 06/01/2026 16:30:00
                        // check điều kiện xóa với đơn thụ lý xx lại sơ thẩm
                        if (oT.HINHTHUCNHANDON == 2597)
                        {
                            Xoa_An_XxlaiST(oPer, IDVuViec);
                        }
                        else
                        {
                            Xoa_An(oPer, IDVuViec);
                        }
                        if (IDVuViec == VuAnID)
                            Session[ENUM_LOAIAN.AN_HANHCHINH] = 0;
                    }
                    //để sửa lỗi mất menu khi xóa vụ án, anhvh add trường hợp xóa vụ án và uppdate lại idvuan =0 để giải phóng việc gim vụ án
                    QT_NGUOISUDUNG oNSD_ = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if (oNSD_.IDANHANHCHINH == IDVuViec)
                    {
                        oNSD_.IDANHANHCHINH = 0;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }
        }
        private void createHoso_xetxulaiPhuctham(decimal vDonID)
        {
            //Toa Phuc Tham ID
            decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Tao Ho so và Thụ ly Phuc Tham khi GDT huy xet xu lai Phuc Tham
            AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
            if (oDon != null)
            {
                AHC_DON oDON_new = new AHC_DON();
                oDON_new.TOAANID = oDon.TOAANID;
                oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                oDON_new.SOTHUTU = oDon.SOTHUTU;
                oDON_new.HINHTHUCNHANDON = 998;//an do GDT huy xet xu lai Phuc Tham
                oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                oDON_new.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                oDON_new.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                oDON_new.LOAIDON = oDon.LOAIDON;
                oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                oDON_new.USERTT_EMAIL = oDon.USERTT_EMAIL;
                oDON_new.USERTT_ID = oDon.USERTT_ID;
                oDON_new.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                oDON_new.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                oDON_new.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;
                oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oDON_new.NGAYTAO = DateTime.Now;
                AHC_DON_BL dsBL = new AHC_DON_BL();
                oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                oDON_new.MABAOMAT = oDon.MABAOMAT;
                oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDON_new.QHPLTKID = oDon.QHPLTKID;
                oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                //oDON_new.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                oDON_new.DONID_TOACU = oDon.DONID_TOACU;
                //update 14082025
                if (oDON_new.TOA_GIAIQUYET_ID == null) oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;
                if (oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID == null)
                    oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID = oDon.TOAPHUCTHAMID;

                dt.AHC_DON.Add(oDON_new);
                dt.SaveChanges();
                //Session[ENUM_SESSION.SESSION_DONVIID] = oDON_new.TOAANID;
                Session[ENUM_LOAIAN.AN_HANHCHINH] = oDON_new.ID;

                //them ma giai doan cap Phuc tham 
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("6", oDON_new.ID, 3, (decimal)oDON_new.TOAANID, LoginDonViID, 0, 0, 0);

                //Câp dương su vụ án
                List<AHC_DON_DUONGSU> lst = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID).ToList<AHC_DON_DUONGSU>();
                foreach (AHC_DON_DUONGSU vDuongsu_old in lst)
                {
                    AHC_DON_DUONGSU vDuongsu_new = new AHC_DON_DUONGSU();
                    vDuongsu_new.DONID = oDON_new.ID;
                    vDuongsu_new.MADUONGSU = vDuongsu_old.MADUONGSU;
                    vDuongsu_new.TENDUONGSU = vDuongsu_old.TENDUONGSU;
                    vDuongsu_new.ISDAIDIEN = vDuongsu_old.ISDAIDIEN;
                    vDuongsu_new.TUCACHTOTUNG_MA = vDuongsu_old.TUCACHTOTUNG_MA;
                    vDuongsu_new.LOAIDUONGSU = vDuongsu_old.LOAIDUONGSU;
                    vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                    vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                    vDuongsu_new.TAMTRUID = vDuongsu_old.TAMTRUID;
                    vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                    vDuongsu_new.HKTTID = vDuongsu_old.HKTTID;
                    vDuongsu_new.HKTTCHITIET = vDuongsu_old.HKTTCHITIET;
                    vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                    vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                    vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                    vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                    vDuongsu_new.NGUOIDAIDIEN = vDuongsu_old.NGUOIDAIDIEN;
                    vDuongsu_new.CHUCVU = vDuongsu_old.CHUCVU;
                    vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vDuongsu_new.NGAYTAO = DateTime.Now;
                    vDuongsu_new.NDD_DIACHIID = vDuongsu_old.NDD_DIACHIID;
                    vDuongsu_new.NDD_DIACHICHITIET = vDuongsu_old.NDD_DIACHICHITIET;
                    vDuongsu_new.ISSOTHAM = vDuongsu_old.ISSOTHAM;
                    vDuongsu_new.ISPHUCTHAM = vDuongsu_old.ISPHUCTHAM;
                    vDuongsu_new.ISGDT = vDuongsu_old.ISGDT;
                    vDuongsu_new.ISDON = vDuongsu_old.ISDON;
                    vDuongsu_new.EMAIL = vDuongsu_old.EMAIL;
                    vDuongsu_new.DIENTHOAI = vDuongsu_old.DIENTHOAI;
                    vDuongsu_new.FAX = vDuongsu_old.FAX;
                    vDuongsu_new.SINHSONG_NUOCNGOAI = vDuongsu_old.SINHSONG_NUOCNGOAI;
                    vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                    vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;
                    vDuongsu_new.DIACHICOQUAN = vDuongsu_old.DIACHICOQUAN;
                    vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;
                    //hoangndh - vnpt 140725
                    vDuongsu_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_DUONGSU.Add(vDuongsu_new);
                    dt.SaveChanges();

                    //Ban giao tai lieu
                    List<AHC_DON_TAILIEU> lstTaiLieu = dt.AHC_DON_TAILIEU.Where(x => x.DONID == vDonID && x.NGUOIBANGIAO == vDuongsu_old.ID).ToList<AHC_DON_TAILIEU>();
                    foreach (AHC_DON_TAILIEU vdonFile_old in lstTaiLieu)
                    {
                        AHC_DON_TAILIEU donFile_new = new AHC_DON_TAILIEU();
                        donFile_new.DONID = oDON_new.ID;
                        donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                        donFile_new.TENFILE = vdonFile_old.TENFILE;
                        donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                        donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                        donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        donFile_new.NGAYTAO = DateTime.Now;
                        donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                        donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                        donFile_new.NGUOIBANGIAO = vDuongsu_new.ID; //Luu duong su moi
                        donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                        donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;
                        // update 130825
                        donFile_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHC_DON_TAILIEU.Add(donFile_new);
                        dt.SaveChanges();
                    }

                }
                // Phan cong Tham phan
                List<AHC_DON_THAMPHAN> lstThamPhan = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == "VTTP_GIAIQUYETDON").ToList<AHC_DON_THAMPHAN>();
                foreach (AHC_DON_THAMPHAN vThamphan_old in lstThamPhan)
                {
                    AHC_DON_THAMPHAN vThamphan_new = new AHC_DON_THAMPHAN();
                    vThamphan_new.DONID = oDON_new.ID;
                    vThamphan_new.CANBOID = vThamphan_old.CANBOID;
                    vThamphan_new.MAVAITRO = vThamphan_old.MAVAITRO;
                    vThamphan_new.NGAYPHANCONG = vThamphan_old.NGAYPHANCONG;
                    vThamphan_new.NGAYNHANPHANCONG = vThamphan_old.NGAYNHANPHANCONG;
                    vThamphan_new.NGAYTHAMGIA = vThamphan_old.NGAYTHAMGIA;
                    vThamphan_new.NGAYKETTHUC = vThamphan_old.NGAYKETTHUC;
                    vThamphan_new.NGUOIPHANCONGID = vThamphan_old.NGUOIPHANCONGID;
                    vThamphan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vThamphan_new.NGAYTAO = DateTime.Now;
                    vThamphan_new.ID_PHAN_CONG_AN = vThamphan_old.ID_PHAN_CONG_AN;
                    vThamphan_new.THUKYID = vThamphan_old.THUKYID;
                    //hoangndh - vnpt 140725
                    vThamphan_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_THAMPHAN.Add(vThamphan_new);
                    dt.SaveChanges();
                }
                //Xu ly don
                List<AHC_DON_XULY> lstXulyDon = dt.AHC_DON_XULY.Where(x => x.DONID == vDonID && x.TOAANID == oDon.TOAANID).ToList<AHC_DON_XULY>();
                foreach (AHC_DON_XULY vXulyDon_old in lstXulyDon)
                {
                    AHC_DON_XULY vXulyDon_new = new AHC_DON_XULY();
                    vXulyDon_new.DONID = oDON_new.ID;
                    vXulyDon_new.LOAIGIAIQUYET = vXulyDon_old.LOAIGIAIQUYET;
                    vXulyDon_new.NGAYGQ_YC = vXulyDon_old.NGAYGQ_YC;
                    vXulyDon_new.LYDO = vXulyDon_old.LYDO;
                    vXulyDon_new.CDTN_TOAANID = vXulyDon_old.CDTN_TOAANID;
                    vXulyDon_new.CDTN_NGAYNHAN = vXulyDon_old.CDTN_NGAYNHAN;
                    vXulyDon_new.CDNN_TENCQ = vXulyDon_old.CDNN_TENCQ;
                    vXulyDon_new.TRADON_CANCUID = vXulyDon_old.TRADON_CANCUID;
                    vXulyDon_new.NGAYTAO = DateTime.Now;
                    vXulyDon_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vXulyDon_new.CDNN_NGAYCHUYEN = vXulyDon_old.CDNN_NGAYCHUYEN;
                    vXulyDon_new.TRADON_LYDOID = vXulyDon_old.TRADON_LYDOID;
                    vXulyDon_new.TRADON_NGAYTRA = vXulyDon_old.TRADON_NGAYTRA;
                    vXulyDon_new.YCBS_NGAYYEUCAU = vXulyDon_old.YCBS_NGAYYEUCAU;
                    vXulyDon_new.YCBS_NOIDUNG = vXulyDon_old.YCBS_NOIDUNG;
                    vXulyDon_new.CDTN_NGAYCHUYEN = vXulyDon_old.CDTN_NGAYCHUYEN;
                    vXulyDon_new.SOTHONGBAO = vXulyDon_old.SOTHONGBAO;
                    vXulyDon_new.FILEID = vXulyDon_old.FILEID;
                    vXulyDon_new.YCBS_THOIHAN = vXulyDon_old.YCBS_THOIHAN;
                    vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                    vXulyDon_new.NGAYTHONGBAO = vXulyDon_old.NGAYTHONGBAO;
                    vXulyDon_new.DON_CHITIETID = vXulyDon_old.DON_CHITIETID;
                    vXulyDon_new.DON_XULYID = vXulyDon_old.DON_XULYID;
                    //hoangndh - vnpt 140725
                    vXulyDon_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_XULY.Add(vXulyDon_new);
                    dt.SaveChanges();
                }
                //Tam ung an phi
                List<AHC_ANPHI> lstAP = dt.AHC_ANPHI.Where(x => x.DONID == vDonID).ToList();
                foreach (AHC_ANPHI vAP_old in lstAP)
                {
                    AHC_ANPHI vAP_new = new AHC_ANPHI();
                    vAP_new.DONID = oDON_new.ID;
                    vAP_new.GIATRITRANHCHAP = vAP_old.GIATRITRANHCHAP;
                    vAP_new.MUCGIAMANPHI = vAP_old.MUCGIAMANPHI;
                    vAP_new.TAMUNGANPHI = vAP_old.TAMUNGANPHI;
                    vAP_new.ANPHI = vAP_old.ANPHI;
                    vAP_new.HANNOP = vAP_old.HANNOP;
                    vAP_new.SONGAYGIAHAN = vAP_old.SONGAYGIAHAN;
                    vAP_new.TINHTRANG = vAP_old.TINHTRANG;
                    vAP_new.NGAYNOPANPHI = vAP_old.NGAYNOPANPHI;
                    vAP_new.NGAYNOPBIENLAI = vAP_old.NGAYNOPBIENLAI;
                    vAP_new.SOBIENLAI = vAP_old.SOBIENLAI;
                    vAP_new.NGUOINHANID = vAP_old.NGUOINHANID;
                    vAP_new.GHICHU = vAP_old.GHICHU;
                    vAP_new.NGAYTAO = DateTime.Now;
                    vAP_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vAP_new.HANNOP_SONGAY = vAP_old.HANNOP_SONGAY;
                    vAP_new.SOTHONGBAO = vAP_old.SOTHONGBAO;
                    vAP_new.NGAYTHONGBAO = vAP_old.NGAYTHONGBAO;
                    //hoangndh - vnpt 140725
                    vAP_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_ANPHI.Add(vAP_new);
                    dt.SaveChanges();
                }
                //Thong tin ban an, QD kêt thuc So tham
                AHC_SOTHAM_BANAN vBA_old = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == vDonID).FirstOrDefault();
                if (vBA_old != null)
                {
                    AHC_SOTHAM_BANAN vBA_new = new AHC_SOTHAM_BANAN();
                    vBA_new.DONID = oDON_new.ID;
                    vBA_new.LOAIQUANHE = vBA_old.LOAIQUANHE;
                    vBA_new.QUANHEPHAPLUATID = vBA_old.QUANHEPHAPLUATID;
                    vBA_new.SOBANAN = vBA_old.SOBANAN;
                    vBA_new.NGAYMOPHIENTOA = vBA_old.NGAYMOPHIENTOA;
                    vBA_new.NGAYTUYENAN = vBA_old.NGAYTUYENAN;
                    vBA_new.NGAYHIEULUC = vBA_old.NGAYHIEULUC;
                    vBA_new.XETXUCONGKHAI = vBA_old.XETXUCONGKHAI;
                    vBA_new.YEUTONUOCNGOAI = vBA_old.YEUTONUOCNGOAI;
                    vBA_new.GHICHU = vBA_old.GHICHU;
                    vBA_new.NGAYTAO = vBA_old.NGAYTAO;
                    vBA_new.NGUOITAO = vBA_old.NGUOITAO;
                    vBA_new.NGAYSUA = vBA_old.NGAYSUA;
                    vBA_new.NGUOISUA = vBA_old.NGUOISUA;
                    vBA_new.NGAYVKSNHAN = vBA_old.NGAYVKSNHAN;
                    vBA_new.ISVKSTHAMGIA = vBA_old.ISVKSTHAMGIA;
                    vBA_new.TOAANID = vBA_old.TOAANID;
                    vBA_new.QHPLTKID = vBA_old.QHPLTKID;
                    vBA_new.TK_ISQUAHAN = vBA_old.TK_ISQUAHAN;
                    vBA_new.TK_QUAHAN_KHACHQUAN = vBA_old.TK_QUAHAN_KHACHQUAN;
                    vBA_new.TK_QUAHAN_CHUQUAN = vBA_old.TK_QUAHAN_CHUQUAN;
                    vBA_new.QUANHEPHAPLUAT_NAME = vBA_old.QUANHEPHAPLUAT_NAME;
                    dt.AHC_SOTHAM_BANAN.Add(vBA_new);
                    dt.SaveChanges();
                }
                List<AHC_SOTHAM_QUYETDINH> LstQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID).ToList();
                if (LstQD.Count > 0)
                {
                    foreach (AHC_SOTHAM_QUYETDINH vQD_old in LstQD)
                    {
                        AHC_SOTHAM_QUYETDINH vQD_new = new AHC_SOTHAM_QUYETDINH();
                        vQD_new.DONID = oDON_new.ID;
                        vQD_new.SOQD = vQD_old.SOQD;
                        vQD_new.NGAYQD = vQD_old.NGAYQD;
                        vQD_new.LOAIQDID = vQD_old.LOAIQDID;
                        vQD_new.QUYETDINHID = vQD_old.QUYETDINHID;
                        vQD_new.LYDOID = vQD_old.LYDOID;
                        vQD_new.HIEULUCTU = vQD_old.HIEULUCTU;
                        vQD_new.HIEULUCDEN = vQD_old.HIEULUCDEN;
                        vQD_new.THOIHANTHANG = vQD_old.THOIHANTHANG;
                        vQD_new.THOIHANNGAY = vQD_old.THOIHANNGAY;
                        vQD_new.NGAYKETTHUCTHEOLUAT = vQD_old.NGAYKETTHUCTHEOLUAT;
                        vQD_new.NGUOIKYID = vQD_old.NGUOIKYID;
                        vQD_new.CHUCVU = vQD_old.CHUCVU;
                        vQD_new.GHICHU = vQD_old.GHICHU;
                        vQD_new.NGAYTAO = vQD_old.NGAYTAO;
                        vQD_new.NGUOITAO = vQD_old.NGUOITAO;
                        vQD_new.NGAYSUA = vQD_old.NGAYSUA;
                        vQD_new.NGUOISUA = vQD_old.NGUOISUA;
                        vQD_new.TENFILE = vQD_old.TENFILE;
                        vQD_new.KIEUFILE = vQD_old.KIEUFILE;
                        vQD_new.NOIDUNGFILE = vQD_old.NOIDUNGFILE;
                        vQD_new.TOAANID = vQD_old.TOAANID;
                        vQD_new.QHPLTKID = vQD_old.QHPLTKID;
                        vQD_new.NGUOIYEUCAUID = vQD_old.NGUOIYEUCAUID;
                        vQD_new.NGUOIBIYEUCAUID = vQD_old.NGUOIBIYEUCAUID;
                        vQD_new.FILEID = vQD_old.FILEID;
                        vQD_new.NGAYMOPT = vQD_old.NGAYMOPT;
                        vQD_new.DIADIEMMOPT = vQD_old.DIADIEMMOPT;
                        vQD_new.LYDO_NAME = vQD_old.LYDO_NAME;
                        //hoangndh-vnpt 140725
                        vQD_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHC_SOTHAM_QUYETDINH.Add(vQD_new);
                        dt.SaveChanges();
                    }
                }
                //Chuyen nhan an
                List<AHC_CHUYEN_NHAN_AN> LstCN = dt.AHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == vDonID).ToList();
                foreach (AHC_CHUYEN_NHAN_AN voND_old in LstCN)
                {
                    AHC_CHUYEN_NHAN_AN oND = new AHC_CHUYEN_NHAN_AN();
                    oND.VUANID = oDON_new.ID;
                    oND.TOACHUYENID = oDon.TOAANID;
                    oND.TOANHANID = LoginDonViID;
                    oND.NGAYGIAO = DateTime.Now;
                    oND.TRUONGHOPGIAONHANID = 998;
                    oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    oND.GHICHU_GIAO = null;
                    oND.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
                    oND.NGAYTAO = DateTime.Now;
                    //hoangndh-vnpt 140725
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_CHUYEN_NHAN_AN.Add(oND);
                    dt.SaveChanges();
                }
                //ket thuc an Hanh Chinh
            }

        }

        // VNPT HOANGNDH 03/12/2025 thụ lý xét xử lại ST
        private void createHoso_xetxulaiSotham(decimal vDonID)
        {
            //Toa Phuc Tham ID
            decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Tao Ho so và Thụ ly Phuc Tham khi GDT huy xet xu lai ST
            AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
            if (oDon != null)
            {
                AHC_DON oDON_new = new AHC_DON();
                oDON_new.TOAANID = oDon.TOAANID;
                oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                oDON_new.SOTHUTU = oDon.SOTHUTU;
                oDON_new.HINHTHUCNHANDON = Convert.ToDecimal(ENUM_TRUONGHOP_GIAONHAN.GDT_HUY_TRA_VE_ST);//an do GDT huy xet xu lai Phuc Tham
                oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                oDON_new.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                oDON_new.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                oDON_new.LOAIDON = oDon.LOAIDON;
                oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                oDON_new.USERTT_EMAIL = oDon.USERTT_EMAIL;
                oDON_new.USERTT_ID = oDon.USERTT_ID;
                oDON_new.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                oDON_new.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                oDON_new.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;
                oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oDON_new.NGAYTAO = DateTime.Now;
                AHC_DON_BL dsBL = new AHC_DON_BL();
                oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                oDON_new.MABAOMAT = oDon.MABAOMAT;
                oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDON_new.QHPLTKID = oDon.QHPLTKID;
                //oDON_new.THONGTINTHEM = oDon.THONGTINTHEM;
                oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                //oDON_new.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                oDON_new.DONID_TOACU = oDon.DONID_TOACU;
                oDON_new.TRUONGHOPTHULY = oDon.TRUONGHOPTHULY;
                oDON_new.VUANGOCID = oDon.VUANGOCID;
                oDON_new.IS_TACHAN = oDon.IS_TACHAN;
                oDON_new.HOAGIAI_TRANGTHAI = oDon.HOAGIAI_TRANGTHAI;
                // Số quyết định, loại quyết định,ngày quyết định,hành vi hành chính bị kiện, nội dung khởi kiện, tiến hành đối thoại
                oDON_new.SOQD = oDon.SOQD;
                oDON_new.NGAYQD = oDon.NGAYQD;
                oDON_new.TENQD = oDon.TENQD;
                oDON_new.HANHVIHC = oDon.HANHVIHC;
                oDON_new.TOMTATHANHVIHCBIKIEN = oDon.TOMTATHANHVIHCBIKIEN;

                if (oDon.TOA_GIAIQUYET_ID != null)
                {
                    oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;
                }
                else
                {
                    oDON_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                }
                oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID = oDon.TOAPHUCTHAMID;
                dt.AHC_DON.Add(oDON_new);
                dt.SaveChanges();
                //Session[ENUM_SESSION.SESSION_DONVIID] = oDON_new.TOAANID;
                Session[ENUM_LOAIAN.AN_HANHCHINH] = oDON_new.ID;

                Dictionary<decimal?, decimal?> MAP_IDDUONGSUOLD_IDDUONGSUNEW = new Dictionary<decimal?, decimal?>();
                Dictionary<decimal?, decimal> MAP_ANPHIIDOLD_ANPHIIDNEW = new Dictionary<decimal?, decimal>();
                Dictionary<decimal?, decimal> MAP_CHITIETOLD_CHITIETIDNEW = new Dictionary<decimal?, decimal>();
                Dictionary<decimal?, decimal> MAP_FILEOLD_FILEIDNEW = new Dictionary<decimal?, decimal>();


                //Câp dương su vụ án
                List<AHC_DON_DUONGSU> lst = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID).ToList<AHC_DON_DUONGSU>();
                foreach (AHC_DON_DUONGSU vDuongsu_old in lst)
                {
                    AHC_DON_DUONGSU vDuongsu_new = new AHC_DON_DUONGSU();
                    vDuongsu_new.DONID = oDON_new.ID;
                    vDuongsu_new.MADUONGSU = vDuongsu_old.MADUONGSU;
                    vDuongsu_new.TENDUONGSU = vDuongsu_old.TENDUONGSU;
                    vDuongsu_new.ISDAIDIEN = vDuongsu_old.ISDAIDIEN;
                    vDuongsu_new.TUCACHTOTUNG_MA = vDuongsu_old.TUCACHTOTUNG_MA;
                    vDuongsu_new.LOAIDUONGSU = vDuongsu_old.LOAIDUONGSU;
                    vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                    vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                    vDuongsu_new.TAMTRUID = vDuongsu_old.TAMTRUID;
                    vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                    vDuongsu_new.HKTTID = vDuongsu_old.HKTTID;
                    vDuongsu_new.HKTTCHITIET = vDuongsu_old.HKTTCHITIET;
                    vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                    vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                    vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                    vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                    vDuongsu_new.NGUOIDAIDIEN = vDuongsu_old.NGUOIDAIDIEN;
                    vDuongsu_new.CHUCVU = vDuongsu_old.CHUCVU;

                    vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vDuongsu_new.NGAYTAO = DateTime.Now;

                    vDuongsu_new.NGUOISUA = vDuongsu_old.NGUOISUA;
                    vDuongsu_new.NGAYSUA = vDuongsu_old.NGAYSUA;

                    vDuongsu_new.NDD_DIACHIID = vDuongsu_old.NDD_DIACHIID;
                    vDuongsu_new.NDD_DIACHICHITIET = vDuongsu_old.NDD_DIACHICHITIET;
                    vDuongsu_new.ISSOTHAM = vDuongsu_old.ISSOTHAM;
                    vDuongsu_new.ISPHUCTHAM = vDuongsu_old.ISPHUCTHAM;
                    vDuongsu_new.ISGDT = vDuongsu_old.ISGDT;
                    vDuongsu_new.ISDON = vDuongsu_old.ISDON;

                    vDuongsu_new.EMAIL = vDuongsu_old.EMAIL;
                    vDuongsu_new.DIENTHOAI = vDuongsu_old.DIENTHOAI;
                    vDuongsu_new.FAX = vDuongsu_old.FAX;

                    vDuongsu_new.SINHSONG_NUOCNGOAI = vDuongsu_old.SINHSONG_NUOCNGOAI;
                    vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                    vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;

                    vDuongsu_new.DIACHICOQUAN = vDuongsu_old.DIACHICOQUAN;
                    vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;

                    vDuongsu_new.ISDONCHITIET = vDuongsu_old.ISDONCHITIET;
                    vDuongsu_new.ISDAIDIEN_DONCHITIET = vDuongsu_old.ISDAIDIEN_DONCHITIET;

                    vDuongsu_new.SO_CCCD = vDuongsu_old.SO_CCCD;
                    vDuongsu_new.SO_HO_CHIEU = vDuongsu_old.SO_HO_CHIEU;

                    vDuongsu_new.TOA_GIAIQUYET_ID = vDuongsu_old.TOA_GIAIQUYET_ID;
                    vDuongsu_new.CHK_KHONG_CO = vDuongsu_old.CHK_KHONG_CO;
                    vDuongsu_new.XACTHUC_DLDCQG = vDuongsu_old.XACTHUC_DLDCQG;

                    //update 14082025
                    if (vDuongsu_old.TOA_GIAIQUYET_ID == null)
                    {
                        vDuongsu_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    else
                    {
                        vDuongsu_new.TOA_GIAIQUYET_ID = vDuongsu_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHC_DON_DUONGSU.Add(vDuongsu_new);
                    dt.SaveChanges();

                    MAP_IDDUONGSUOLD_IDDUONGSUNEW[vDuongsu_old.ID] = vDuongsu_new.ID;

                    //Ban giao tai lieu
                    List<AHC_DON_TAILIEU> lstTaiLieu = dt.AHC_DON_TAILIEU.Where(x => x.DONID == vDonID && x.NGUOIBANGIAO == vDuongsu_old.ID).ToList<AHC_DON_TAILIEU>();
                    foreach (AHC_DON_TAILIEU vdonFile_old in lstTaiLieu)
                    {
                        AHC_DON_TAILIEU donFile_new = new AHC_DON_TAILIEU();
                        donFile_new.DONID = oDON_new.ID;
                        donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                        donFile_new.TENFILE = vdonFile_old.TENFILE;
                        donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                        donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                        donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        donFile_new.NGAYTAO = DateTime.Now;
                        donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                        donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                        donFile_new.NGUOIBANGIAO = vDuongsu_new.ID; //Luu duong su moi
                        donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                        donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;

                        //update 14082025
                        if (vdonFile_old.TOA_GIAIQUYET_ID == null)
                        {
                            donFile_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        else
                        {
                            donFile_new.TOA_GIAIQUYET_ID = vdonFile_old.TOA_GIAIQUYET_ID;
                        }
                        dt.AHC_DON_TAILIEU.Add(donFile_new);
                        dt.SaveChanges();
                    }

                }

                //List<AHC_FILE> aDSFiles = dt.AHC_FILE.Where(x => x.DONID == vDonID).ToList<AHC_FILE>();
                //foreach (AHC_FILE aDSFile_OLD in aDSFiles)
                //{
                //    AHC_FILE ADS_FILE_NEW = new AHC_FILE()
                //    {
                //        TOAANID = aDSFile_OLD.TOAANID,
                //        NAM = aDSFile_OLD.NAM,
                //        DONID = oDON_new.ID,
                //        MAGIAIDOAN = aDSFile_OLD.MAGIAIDOAN,
                //        BIEUMAUID = aDSFile_OLD.BIEUMAUID,
                //        LOAIFILE = aDSFile_OLD.LOAIFILE,
                //        KIEUFILE = aDSFile_OLD.KIEUFILE,
                //        NOIDUNG = aDSFile_OLD.NOIDUNG,
                //        NGUOITAO = aDSFile_OLD.NGUOITAO,
                //        NGAYTAO = aDSFile_OLD.NGAYTAO,
                //        TENFILE = aDSFile_OLD.TENFILE,
                //        STT = aDSFile_OLD.STT,
                //        URL = aDSFile_OLD.URL,
                //        NGAYGUI = aDSFile_OLD.NGAYGUI,
                //        STB_PHU = aDSFile_OLD.STB_PHU,
                //    };

                //    dt.AHC_FILE.Add(ADS_FILE_NEW);
                //    dt.SaveChanges();

                //    MAP_FILEOLD_FILEIDNEW[aDSFile_OLD.ID] = ADS_FILE_NEW.ID;
                //}

                HashSet<string> LIST_BM_THONGTINDON_GIAI_QUYET_DON = new HashSet<string>();
                LIST_BM_THONGTINDON_GIAI_QUYET_DON.UnionWith(ENUM_PHATHANH_BIEUMAU_DS.ADS_ST_GIAI_QUYET_DON);
                LIST_BM_THONGTINDON_GIAI_QUYET_DON.UnionWith(ENUM_PHATHANH_BIEUMAU_DS.BM_Thongtindon_AHC);
                LIST_BM_THONGTINDON_GIAI_QUYET_DON.UnionWith(ENUM_PHATHANH_BIEUMAU_DS.BM_THONGTINDONST_ADS);
                LIST_BM_THONGTINDON_GIAI_QUYET_DON.UnionWith(ENUM_PHATHANH_BIEUMAU_DS.BM_GIAIQUYETDON_AHC);

                List<AHC_FILE> oldFiles = dt.AHC_FILE
                    .Where(x => x.DONID == vDonID)
                    .ToList();

                List<decimal> bmIds = oldFiles
                    .Select(x => (decimal)x.BIEUMAUID)
                    .Distinct()
                    .ToList();

                Dictionary<decimal, string> bmDict = dt.DM_BIEUMAU
                    .Where(x => bmIds.Contains(x.ID))
                    .ToDictionary(x => x.ID, x => x.MABM);

                Dictionary<AHC_FILE, AHC_FILE> tempMap = new Dictionary<AHC_FILE, AHC_FILE>();
                foreach (AHC_FILE oldFile in oldFiles)
                {
                    decimal bieumauId = (decimal)oldFile.BIEUMAUID;
                    string mabm;
                    if (!bmDict.TryGetValue(bieumauId, out mabm))
                        continue;
                    if (!LIST_BM_THONGTINDON_GIAI_QUYET_DON.Contains(mabm))
                        continue;
                    AHC_FILE newFile = new AHC_FILE
                    {
                        TOAANID = oldFile.TOAANID,
                        NAM = oldFile.NAM,
                        DONID = oDON_new.ID,
                        MAGIAIDOAN = oldFile.MAGIAIDOAN,
                        BIEUMAUID = oldFile.BIEUMAUID,
                        LOAIFILE = oldFile.LOAIFILE,
                        KIEUFILE = oldFile.KIEUFILE,
                        NOIDUNG = oldFile.NOIDUNG,
                        NGUOITAO = oldFile.NGUOITAO,
                        NGAYTAO = oldFile.NGAYTAO,
                        TENFILE = oldFile.TENFILE,
                        STT = oldFile.STT,
                        URL = oldFile.URL,
                        NGAYGUI = oldFile.NGAYGUI,
                        STB_PHU = oldFile.STB_PHU
                    };
                    dt.AHC_FILE.Add(newFile);
                    tempMap.Add(oldFile, newFile);

                }
                dt.SaveChanges();
                foreach (KeyValuePair<AHC_FILE, AHC_FILE> kv in tempMap)
                {
                    MAP_FILEOLD_FILEIDNEW[kv.Key.ID] = kv.Value.ID;
                }

                // Phan cong Tham phan
                List<AHC_DON_THAMPHAN> lstThamPhan = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == "VTTP_GIAIQUYETDON").ToList<AHC_DON_THAMPHAN>();
                foreach (AHC_DON_THAMPHAN vThamphan_old in lstThamPhan)
                {
                    AHC_DON_THAMPHAN vThamphan_new = new AHC_DON_THAMPHAN();
                    vThamphan_new.DONID = oDON_new.ID;
                    vThamphan_new.CANBOID = vThamphan_old.CANBOID;
                    vThamphan_new.MAVAITRO = vThamphan_old.MAVAITRO;
                    vThamphan_new.NGAYPHANCONG = vThamphan_old.NGAYPHANCONG;
                    vThamphan_new.NGAYNHANPHANCONG = vThamphan_old.NGAYNHANPHANCONG;
                    vThamphan_new.NGAYTHAMGIA = vThamphan_old.NGAYTHAMGIA;
                    vThamphan_new.NGAYKETTHUC = vThamphan_old.NGAYKETTHUC;
                    vThamphan_new.NGUOIPHANCONGID = vThamphan_old.NGUOIPHANCONGID;
                    vThamphan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vThamphan_new.NGAYTAO = DateTime.Now;
                    vThamphan_new.ID_PHAN_CONG_AN = vThamphan_old.ID_PHAN_CONG_AN;
                    vThamphan_new.THUKYID = vThamphan_old.THUKYID;
                    //update 14082025
                    if (vThamphan_old.TOA_GIAIQUYET_ID == null)
                    {
                        vThamphan_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    else
                    {
                        vThamphan_new.TOA_GIAIQUYET_ID = vThamphan_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHC_DON_THAMPHAN.Add(vThamphan_new);
                    dt.SaveChanges();
                }

                List<DON_CHITIET> dON_CHITIETs = dt.DON_CHITIET.Where(x => x.DONID == vDonID && x.LOAIANID == 6).ToList<DON_CHITIET>();
                foreach (DON_CHITIET dON_CHITIET_OLD in dON_CHITIETs)
                {
                    var dON_CHITIET_NEW = new DON_CHITIET();
                    dON_CHITIET_NEW.DONID = oDON_new.ID; // gán DONID mới
                    dON_CHITIET_NEW.LOAIANID = dON_CHITIET_OLD.LOAIANID;
                    dON_CHITIET_NEW.TOAANID = dON_CHITIET_OLD.TOAANID;
                    dON_CHITIET_NEW.HINHTHUCNHANDON = dON_CHITIET_OLD.HINHTHUCNHANDON;
                    dON_CHITIET_NEW.NGAYVIETDON = dON_CHITIET_OLD.NGAYVIETDON;
                    dON_CHITIET_NEW.NGAYNHANDON = dON_CHITIET_OLD.NGAYNHANDON;
                    dON_CHITIET_NEW.CANBONHANDONID = dON_CHITIET_OLD.CANBONHANDONID;
                    dON_CHITIET_NEW.THAMPHANKYNHANDON = dON_CHITIET_OLD.THAMPHANKYNHANDON;
                    dON_CHITIET_NEW.YEUTONUOCNGOAI = dON_CHITIET_OLD.YEUTONUOCNGOAI;
                    dON_CHITIET_NEW.LOAIDON = dON_CHITIET_OLD.LOAIDON;
                    dON_CHITIET_NEW.USERTT_EMAIL = dON_CHITIET_OLD.USERTT_EMAIL;
                    dON_CHITIET_NEW.USERTT_ID = dON_CHITIET_OLD.USERTT_ID;
                    dON_CHITIET_NEW.USERTT_NGAYTAO = dON_CHITIET_OLD.USERTT_NGAYTAO;
                    dON_CHITIET_NEW.USERTT_NGAYGUI = dON_CHITIET_OLD.USERTT_NGAYGUI;
                    dON_CHITIET_NEW.USERTT_NGAYBOSUNG = dON_CHITIET_OLD.USERTT_NGAYBOSUNG;
                    dON_CHITIET_NEW.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dON_CHITIET_NEW.NGAYTAO = DateTime.Now;
                    dON_CHITIET_NEW.NGUOISUA = dON_CHITIET_OLD.NGUOISUA;
                    dON_CHITIET_NEW.NGAYSUA = dON_CHITIET_OLD.NGAYSUA;
                    dON_CHITIET_NEW.NOIDUNGKHOIKIEN = dON_CHITIET_OLD.NOIDUNGKHOIKIEN;
                    dON_CHITIET_NEW.THONGTINTHEM = dON_CHITIET_OLD.THONGTINTHEM;
                    dON_CHITIET_NEW.DONKKID = dON_CHITIET_OLD.DONKKID;
                    dON_CHITIET_NEW.GHICHU = dON_CHITIET_OLD.GHICHU;
                    dON_CHITIET_NEW.TTGQ = dON_CHITIET_OLD.TTGQ;
                    dON_CHITIET_NEW.NOIDUNGTTGQ = dON_CHITIET_OLD.NOIDUNGTTGQ;
                    dON_CHITIET_NEW.DONGUINHANID = dON_CHITIET_OLD.DONGUINHANID;
                    dON_CHITIET_NEW.IS_NHAPAN = dON_CHITIET_OLD.IS_NHAPAN;
                    dON_CHITIET_NEW.TOA_GIAIQUYET_ID = dON_CHITIET_OLD.TOA_GIAIQUYET_ID;

                    dt.DON_CHITIET.Add(dON_CHITIET_NEW);
                    dt.SaveChanges();

                    MAP_CHITIETOLD_CHITIETIDNEW[dON_CHITIET_OLD.ID] = dON_CHITIET_NEW.ID;
                }

                List<DON_DUONGSU_CHITIET> dON_DUONGSU_CHITIETs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONID == vDonID && x.LOAIAN == 6).ToList<DON_DUONGSU_CHITIET>();
                foreach (DON_DUONGSU_CHITIET dON_DUONGSU_CHITIET_OLD in dON_DUONGSU_CHITIETs)
                {
                    DON_DUONGSU_CHITIET dON_DUONGSU_CHITIET_NEW = new DON_DUONGSU_CHITIET();
                    if (dON_DUONGSU_CHITIET_OLD.DUONGSUID != null && MAP_IDDUONGSUOLD_IDDUONGSUNEW.ContainsKey(dON_DUONGSU_CHITIET_OLD.DUONGSUID))
                    {
                        dON_DUONGSU_CHITIET_NEW.DUONGSUID = MAP_IDDUONGSUOLD_IDDUONGSUNEW[dON_DUONGSU_CHITIET_OLD.DUONGSUID];
                    }
                    dON_DUONGSU_CHITIET_NEW.DONID = oDON_new.ID;
                    dON_DUONGSU_CHITIET_NEW.LOAIAN = dON_DUONGSU_CHITIET_OLD.LOAIAN;
                    if (dON_DUONGSU_CHITIET_OLD.DONCHITIETID != null && MAP_CHITIETOLD_CHITIETIDNEW.ContainsKey(dON_DUONGSU_CHITIET_OLD.DONCHITIETID))
                    {
                        dON_DUONGSU_CHITIET_NEW.DONCHITIETID = MAP_CHITIETOLD_CHITIETIDNEW[dON_DUONGSU_CHITIET_OLD.DONCHITIETID];
                    }
                    dON_DUONGSU_CHITIET_NEW.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dON_DUONGSU_CHITIET_NEW.NGAYTAO = DateTime.Now;
                    dON_DUONGSU_CHITIET_NEW.NGUOISUA = dON_DUONGSU_CHITIET_OLD.NGUOISUA;
                    dON_DUONGSU_CHITIET_NEW.NGAYSUA = dON_DUONGSU_CHITIET_OLD.NGAYSUA;
                    if (dON_DUONGSU_CHITIET_OLD.TOA_GIAIQUYET_ID == null)
                    {
                        dON_DUONGSU_CHITIET_NEW.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    else
                    {
                        dON_DUONGSU_CHITIET_NEW.TOA_GIAIQUYET_ID = dON_DUONGSU_CHITIET_OLD.TOA_GIAIQUYET_ID;
                    }
                    dt.DON_DUONGSU_CHITIET.Add(dON_DUONGSU_CHITIET_NEW);
                    dt.SaveChanges();
                }

                List<AHC_DON_THAMGIATOTUNG> aDS_DON_THAMGIATOTUNGs = dt.AHC_DON_THAMGIATOTUNG.Where(x => x.DONID == vDonID).ToList<AHC_DON_THAMGIATOTUNG>();
                foreach (AHC_DON_THAMGIATOTUNG ADS_DON_THAMGIATOTUNG_OLD in aDS_DON_THAMGIATOTUNGs)
                {
                    AHC_DON_THAMGIATOTUNG ADS_DON_THAMGIATOTUNG_NEW = new AHC_DON_THAMGIATOTUNG();
                    ADS_DON_THAMGIATOTUNG_NEW.DONID = oDON_new.ID;
                    ADS_DON_THAMGIATOTUNG_NEW.HOTEN = ADS_DON_THAMGIATOTUNG_OLD.HOTEN;
                    ADS_DON_THAMGIATOTUNG_NEW.TAMTRUID = ADS_DON_THAMGIATOTUNG_OLD.TAMTRUID;
                    ADS_DON_THAMGIATOTUNG_NEW.TAMTRUCHITIET = ADS_DON_THAMGIATOTUNG_OLD.TAMTRUCHITIET;
                    ADS_DON_THAMGIATOTUNG_NEW.HKTTID = ADS_DON_THAMGIATOTUNG_OLD.HKTTID;
                    ADS_DON_THAMGIATOTUNG_NEW.HKTTCHITIET = ADS_DON_THAMGIATOTUNG_OLD.HKTTCHITIET;
                    ADS_DON_THAMGIATOTUNG_NEW.NGAYSINH = ADS_DON_THAMGIATOTUNG_OLD.NGAYSINH;
                    ADS_DON_THAMGIATOTUNG_NEW.THANGSINH = ADS_DON_THAMGIATOTUNG_OLD.THANGSINH;
                    ADS_DON_THAMGIATOTUNG_NEW.NAMSINH = ADS_DON_THAMGIATOTUNG_OLD.NAMSINH;
                    ADS_DON_THAMGIATOTUNG_NEW.GIOITINH = ADS_DON_THAMGIATOTUNG_OLD.GIOITINH;
                    ADS_DON_THAMGIATOTUNG_NEW.TUCACHTGTTID = ADS_DON_THAMGIATOTUNG_OLD.TUCACHTGTTID;
                    ADS_DON_THAMGIATOTUNG_NEW.NGUOIDAIDIEN = ADS_DON_THAMGIATOTUNG_OLD.NGUOIDAIDIEN;
                    ADS_DON_THAMGIATOTUNG_NEW.CHUCVU = ADS_DON_THAMGIATOTUNG_OLD.CHUCVU;
                    ADS_DON_THAMGIATOTUNG_NEW.NGAYTHAMGIA = ADS_DON_THAMGIATOTUNG_OLD.NGAYTHAMGIA;
                    ADS_DON_THAMGIATOTUNG_NEW.NGAYKETTHUC = ADS_DON_THAMGIATOTUNG_OLD.NGAYKETTHUC;
                    ADS_DON_THAMGIATOTUNG_NEW.NGAYTAO = DateTime.Now;
                    ADS_DON_THAMGIATOTUNG_NEW.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    ADS_DON_THAMGIATOTUNG_NEW.NGAYSUA = ADS_DON_THAMGIATOTUNG_OLD.NGAYSUA;
                    ADS_DON_THAMGIATOTUNG_NEW.NGUOISUA = ADS_DON_THAMGIATOTUNG_OLD.NGUOISUA;
                    ADS_DON_THAMGIATOTUNG_NEW.EMAIL = ADS_DON_THAMGIATOTUNG_OLD.EMAIL;
                    ADS_DON_THAMGIATOTUNG_NEW.DIENTHOAI = ADS_DON_THAMGIATOTUNG_OLD.DIENTHOAI;
                    ADS_DON_THAMGIATOTUNG_NEW.FAX = ADS_DON_THAMGIATOTUNG_OLD.FAX;
                    ADS_DON_THAMGIATOTUNG_NEW.HKTTTINHID = ADS_DON_THAMGIATOTUNG_OLD.HKTTTINHID;
                    ADS_DON_THAMGIATOTUNG_NEW.TAMTRUTINHID = ADS_DON_THAMGIATOTUNG_OLD.TAMTRUTINHID;
                    ADS_DON_THAMGIATOTUNG_NEW.ID_DUONGSU_TACC = ADS_DON_THAMGIATOTUNG_OLD.ID_DUONGSU_TACC;
                    ADS_DON_THAMGIATOTUNG_NEW.DUONGSUID = ADS_DON_THAMGIATOTUNG_OLD.DUONGSUID;
                    ADS_DON_THAMGIATOTUNG_NEW.SOCMND = ADS_DON_THAMGIATOTUNG_OLD.SOCMND;
                    ADS_DON_THAMGIATOTUNG_NEW.TEN_VPLS = ADS_DON_THAMGIATOTUNG_OLD.TEN_VPLS;
                    ADS_DON_THAMGIATOTUNG_NEW.DOAN_LS = ADS_DON_THAMGIATOTUNG_OLD.DOAN_LS;
                    ADS_DON_THAMGIATOTUNG_NEW.SO_DK = ADS_DON_THAMGIATOTUNG_OLD.SO_DK;
                    ADS_DON_THAMGIATOTUNG_NEW.NGAY_DK = ADS_DON_THAMGIATOTUNG_OLD.NGAY_DK;
                    ADS_DON_THAMGIATOTUNG_NEW.NGUOIPHANCONGID = ADS_DON_THAMGIATOTUNG_OLD.NGUOIPHANCONGID;
                    ADS_DON_THAMGIATOTUNG_NEW.DIACHI = ADS_DON_THAMGIATOTUNG_OLD.DIACHI;
                    ADS_DON_THAMGIATOTUNG_NEW.CHUCVU_CHUCDANH = ADS_DON_THAMGIATOTUNG_OLD.CHUCVU_CHUCDANH;
                    ADS_DON_THAMGIATOTUNG_NEW.SO_CCCD = ADS_DON_THAMGIATOTUNG_OLD.SO_CCCD;
                    ADS_DON_THAMGIATOTUNG_NEW.SO_HO_CHIEU = ADS_DON_THAMGIATOTUNG_OLD.SO_HO_CHIEU;

                    if (ADS_DON_THAMGIATOTUNG_OLD.TOA_GIAIQUYET_ID == null)
                    {
                        ADS_DON_THAMGIATOTUNG_NEW.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    else
                    {
                        ADS_DON_THAMGIATOTUNG_NEW.TOA_GIAIQUYET_ID = ADS_DON_THAMGIATOTUNG_OLD.TOA_GIAIQUYET_ID;
                    }

                    dt.AHC_DON_THAMGIATOTUNG.Add(ADS_DON_THAMGIATOTUNG_NEW);
                    dt.SaveChanges();
                }

                //Xu ly don
                List<AHC_DON_XULY> lstXulyDon = dt.AHC_DON_XULY.Where(x => (x.DONID == vDonID || x.DON_XULYID == vDonID) && x.TOAANID == oDon.TOAANID).ToList<AHC_DON_XULY>();
                foreach (AHC_DON_XULY vXulyDon_old in lstXulyDon)
                {
                    AHC_DON_XULY vXulyDon_new = new AHC_DON_XULY();
                    if (vXulyDon_old.DONID != null) // trường hợp đơn xử lý là con của là đơn chi tiết thì sẽ null DONID
                    {
                        vXulyDon_new.DONID = oDON_new.ID;
                    }
                    vXulyDon_new.LOAIGIAIQUYET = vXulyDon_old.LOAIGIAIQUYET;
                    vXulyDon_new.NGAYGQ_YC = vXulyDon_old.NGAYGQ_YC;
                    vXulyDon_new.LYDO = vXulyDon_old.LYDO;
                    vXulyDon_new.CDTN_TOAANID = vXulyDon_old.CDTN_TOAANID;
                    vXulyDon_new.CDTN_NGAYNHAN = vXulyDon_old.CDTN_NGAYNHAN;
                    vXulyDon_new.CDNN_TENCQ = vXulyDon_old.CDNN_TENCQ;
                    vXulyDon_new.TRADON_CANCUID = vXulyDon_old.TRADON_CANCUID;
                    vXulyDon_new.NGAYTAO = DateTime.Now;
                    vXulyDon_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vXulyDon_new.CDNN_NGAYCHUYEN = vXulyDon_old.CDNN_NGAYCHUYEN;
                    vXulyDon_new.TRADON_LYDOID = vXulyDon_old.TRADON_LYDOID;
                    vXulyDon_new.TRADON_NGAYTRA = vXulyDon_old.TRADON_NGAYTRA;
                    vXulyDon_new.YCBS_NGAYYEUCAU = vXulyDon_old.YCBS_NGAYYEUCAU;
                    vXulyDon_new.YCBS_NOIDUNG = vXulyDon_old.YCBS_NOIDUNG;
                    vXulyDon_new.CDTN_NGAYCHUYEN = vXulyDon_old.CDTN_NGAYCHUYEN;
                    vXulyDon_new.SOTHONGBAO = vXulyDon_old.SOTHONGBAO;
                    if (vXulyDon_old.FILEID != null && MAP_FILEOLD_FILEIDNEW.ContainsKey(vXulyDon_old.FILEID))
                    {
                        vXulyDon_new.FILEID = MAP_FILEOLD_FILEIDNEW[vXulyDon_old.FILEID];
                    }

                    vXulyDon_new.YCBS_THOIHAN = vXulyDon_old.YCBS_THOIHAN;
                    vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                    vXulyDon_new.NGAYTHONGBAO = vXulyDon_old.NGAYTHONGBAO;
                    if (vXulyDon_old.DON_CHITIETID != null && MAP_CHITIETOLD_CHITIETIDNEW.ContainsKey(vXulyDon_old.DON_CHITIETID))
                    {
                        vXulyDon_new.DON_CHITIETID = MAP_CHITIETOLD_CHITIETIDNEW[vXulyDon_old.DON_CHITIETID];
                        vXulyDon_new.DON_XULYID = oDON_new.ID;
                    }

                    //update 14082025
                    if (vXulyDon_new.TOA_GIAIQUYET_ID == null && vXulyDon_old.TOA_GIAIQUYET_ID == null)
                        vXulyDon_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    else if (vXulyDon_old.TOA_GIAIQUYET_ID != null)
                    {
                        vXulyDon_new.TOA_GIAIQUYET_ID = vXulyDon_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHC_DON_XULY.Add(vXulyDon_new);
                    dt.SaveChanges();


                    ADS_DON_XULY_BL oBLYC = new ADS_DON_XULY_BL();
                    DataTable donYCBSes = oBLYC.AHC_GETALL_DON_YCBS(vDonID, vXulyDon_old.ID, 1, 100);
                    if (donYCBSes != null && donYCBSes.Rows.Count > 0)
                    {
                        foreach (DataRow donYCBS in donYCBSes.Rows)
                        {

                            DON_YEUCAU_BOSUNG obj = new DON_YEUCAU_BOSUNG()
                            {
                                DONID = oDON_new.ID,
                                LOAIAN = Convert.ToDecimal(donYCBS["LOAIAN"]),
                                DON_XULYID = vXulyDon_new.DON_XULYID,
                                LOAIGIAIQUYET = donYCBS["LOAIGIAIQUYET"] != DBNull.Value ? Convert.ToDecimal(donYCBS["LOAIGIAIQUYET"]) : (decimal?)null,
                                NGAYGQ_YC = donYCBS["NGAYGQ_YC"] != DBNull.Value ? Convert.ToDateTime(donYCBS["NGAYGQ_YC"]) : (DateTime?)null,
                                LYDO = donYCBS["LYDO"]?.ToString(),
                                TRADON_CANCUID = donYCBS["TRADON_CANCUID"] != DBNull.Value ? Convert.ToDecimal(donYCBS["TRADON_CANCUID"]) : (decimal?)null,
                                NGAYTAO = donYCBS["NGAYTAO"] != DBNull.Value ? Convert.ToDateTime(donYCBS["NGAYTAO"]) : (DateTime?)null,
                                NGUOITAO = donYCBS["NGUOITAO"]?.ToString(),
                                NGAYSUA = donYCBS["NGAYSUA"] != DBNull.Value ? Convert.ToDateTime(donYCBS["NGAYSUA"]) : (DateTime?)null,
                                NGUOISUA = donYCBS["NGUOISUA"]?.ToString(),
                                CDNN_NGAYCHUYEN = donYCBS["CDNN_NGAYCHUYEN"] != DBNull.Value ? Convert.ToDateTime(donYCBS["CDNN_NGAYCHUYEN"]) : (DateTime?)null,
                                TRADON_LYDOID = donYCBS["TRADON_LYDOID"] != DBNull.Value ? Convert.ToDecimal(donYCBS["TRADON_LYDOID"]) : (decimal?)null,
                                TRADON_NGAYTRA = donYCBS["TRADON_NGAYTRA"] != DBNull.Value ? Convert.ToDateTime(donYCBS["TRADON_NGAYTRA"]) : (DateTime?)null,
                                YCBS_NOIDUNG = donYCBS["YCBS_NOIDUNG"]?.ToString(),
                                SOTHONGBAO = donYCBS["SOTHONGBAO"]?.ToString(),
                                FILEID = donYCBS["FILEID"] != DBNull.Value ? Convert.ToDecimal(donYCBS["FILEID"]) : (decimal?)null,
                                YCBS_THOIHAN = donYCBS["YCBS_THOIHAN"] != DBNull.Value ? Convert.ToDecimal(donYCBS["YCBS_THOIHAN"]) : (decimal?)null,
                                TOAANID = donYCBS["TOAANID"] != DBNull.Value ? Convert.ToDecimal(donYCBS["TOAANID"]) : (decimal?)null,
                                NGAYTHONGBAO = donYCBS["NGAYTHONGBAO"] != DBNull.Value ? Convert.ToDateTime(donYCBS["NGAYTHONGBAO"]) : (DateTime?)null,
                                DON_CHITIETID = donYCBS["DON_CHITIETID"] != DBNull.Value ? Convert.ToDecimal(donYCBS["DON_CHITIETID"]) : (decimal?)null,
                                SOHIEU = donYCBS["SOHIEU"]?.ToString(),
                                NGAYBOSUNG = donYCBS["NGAYBOSUNG"] != DBNull.Value ? Convert.ToDateTime(donYCBS["NGAYBOSUNG"]) : DateTime.Now,
                                DON_XULY_YCBS_ID = vXulyDon_new.ID,
                                STB_PHU = donYCBS["STB_PHU"]?.ToString()

                            };

                            if (obj.FILEID != null && MAP_FILEOLD_FILEIDNEW.ContainsKey(obj.FILEID))
                            {
                                obj.FILEID = MAP_FILEOLD_FILEIDNEW[obj.FILEID];
                            }
                            oBLYC.DON_YCBS_INUP(obj);
                        }
                    }
                }


                //Tam ung an phi
                List<AHC_ANPHI> lstAP = dt.AHC_ANPHI.Where(x => x.DONID == vDonID).ToList();
                foreach (AHC_ANPHI vAP_old in lstAP)
                {
                    AHC_ANPHI vAP_new = new AHC_ANPHI();
                    vAP_new.DONID = oDON_new.ID;
                    vAP_new.GIATRITRANHCHAP = vAP_old.GIATRITRANHCHAP;
                    vAP_new.MUCGIAMANPHI = vAP_old.MUCGIAMANPHI;
                    vAP_new.TAMUNGANPHI = vAP_old.TAMUNGANPHI;
                    vAP_new.ANPHI = vAP_old.ANPHI;
                    vAP_new.HANNOP = vAP_old.HANNOP;
                    vAP_new.SONGAYGIAHAN = vAP_old.SONGAYGIAHAN;
                    vAP_new.TINHTRANG = vAP_old.TINHTRANG;
                    vAP_new.NGAYNOPANPHI = vAP_old.NGAYNOPANPHI;
                    vAP_new.NGAYNOPBIENLAI = vAP_old.NGAYNOPBIENLAI;
                    vAP_new.SOBIENLAI = vAP_old.SOBIENLAI;
                    vAP_new.NGUOINHANID = vAP_old.NGUOINHANID;
                    vAP_new.GHICHU = vAP_old.GHICHU;
                    vAP_new.NGAYTAO = DateTime.Now;
                    vAP_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //vAP_new.DONVITHA_ID = vAP_old.DONVITHA_ID;
                    vAP_new.HANNOP_SONGAY = vAP_old.HANNOP_SONGAY;
                    vAP_new.SOTHONGBAO = vAP_old.SOTHONGBAO;
                    vAP_new.NGAYTHONGBAO = vAP_old.NGAYTHONGBAO;
                    vAP_new.MAGIAIDOAN = vAP_old.MAGIAIDOAN;
                    // vnpt HOANGNDH 05/12/2025 update trường người nộp
                    vAP_new.NGUOINOP = vAP_old.NGUOINOP;
                    if (vAP_old.DUONGSU_ID != null && MAP_IDDUONGSUOLD_IDDUONGSUNEW.ContainsKey(vAP_old.DUONGSU_ID))
                    {
                        vAP_new.DUONGSU_ID = MAP_IDDUONGSUOLD_IDDUONGSUNEW[vAP_old.DUONGSU_ID];
                    }
                    if (vAP_old.DUONGSU_IDS != null && vAP_old.DUONGSU_IDS.Length > 0)
                    {
                        var DuongSuIDSplit = vAP_old.DUONGSU_IDS.Split(',');
                        List<Decimal?> DUONGSUNEWS = new List<Decimal?>();
                        foreach (string DuongSuID in DuongSuIDSplit)
                        {
                            if (DuongSuID != null && DuongSuID != "" && MAP_IDDUONGSUOLD_IDDUONGSUNEW.ContainsKey(Convert.ToDecimal(DuongSuID)))
                            {
                                DUONGSUNEWS.Add(MAP_IDDUONGSUOLD_IDDUONGSUNEW[Convert.ToDecimal(DuongSuID)]);
                            }
                        }
                        vAP_new.DUONGSU_IDS = String.Join(",", DUONGSUNEWS);
                    }

                    if (vAP_old.FILEID != null && MAP_FILEOLD_FILEIDNEW.ContainsKey(vAP_old.FILEID))
                    {
                        vAP_new.FILEID = MAP_FILEOLD_FILEIDNEW[vAP_old.FILEID];
                    }

                    if (vAP_old.MATHONGBAO_OLD != null)
                    {
                        vAP_new.MATHONGBAO_OLD = vAP_old.MATHONGBAO_OLD;
                    }
                    else
                    {
                        DAL.GSTP.DVCQG_THANH_TOAN dVCQG_THANH_TOAN = dt.DVCQG_THANH_TOAN.Where(x => x.ANPHI_ID == vAP_old.ID && x.MALOAIVUVIEC == "6").FirstOrDefault();
                        if (dVCQG_THANH_TOAN != null)
                        {
                            vAP_new.MATHONGBAO_OLD = dVCQG_THANH_TOAN.MA_THONGBAO;
                        }
                    }

                    //update 14082025
                    if (vAP_new.TOA_GIAIQUYET_ID == null && vAP_old.TOA_GIAIQUYET_ID == null)
                        vAP_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    else
                    {
                        vAP_new.TOA_GIAIQUYET_ID = vAP_old.TOA_GIAIQUYET_ID;
                    }

                    dt.AHC_ANPHI.Add(vAP_new);
                    dt.SaveChanges();

                    MAP_ANPHIIDOLD_ANPHIIDNEW[vAP_old.ID] = vAP_new.ID;

                    List<AHC_ANPHI_DUONGSU> aDS_ANPHI_DUONGSUs = DataExtensions.GetAllWithClause<AHC_ANPHI_DUONGSU>($" ANPHI_ID == {vAP_old.ID}");
                    if (aDS_ANPHI_DUONGSUs != null && aDS_ANPHI_DUONGSUs.Count > 0)
                    {
                        foreach (AHC_ANPHI_DUONGSU aDS_ANPHI_DUONGSU_OLD in aDS_ANPHI_DUONGSUs)
                        {
                            AHC_ANPHI_DUONGSU aDS_ANPHI_DUONGSU_NEW = new AHC_ANPHI_DUONGSU();
                            aDS_ANPHI_DUONGSU_NEW.ANPHI_ID = vAP_new.ID;
                            if (MAP_IDDUONGSUOLD_IDDUONGSUNEW.ContainsKey(aDS_ANPHI_DUONGSU_OLD.DUONGSU_ID))
                            {
                                aDS_ANPHI_DUONGSU_NEW.DUONGSU_ID = MAP_IDDUONGSUOLD_IDDUONGSUNEW[aDS_ANPHI_DUONGSU_OLD.DUONGSU_ID];
                            }

                            DataExtensions.Insert<AHC_ANPHI_DUONGSU>(aDS_ANPHI_DUONGSU_NEW);
                        }
                    }

                }

                List<DON_MIENANPHI> dON_MIENANPHIs = DataExtensions.GetAllWithClause<DON_MIENANPHI>($" DONID = {vDonID} AND LOAIAN = 6");
                if (dON_MIENANPHIs != null && dON_MIENANPHIs.Count > 0)
                {
                    foreach (DON_MIENANPHI dON_MIENANPHI_OLD in dON_MIENANPHIs)
                    {
                        DON_MIENANPHI dON_MIENANPH_NEW = new DON_MIENANPHI();
                        if (MAP_ANPHIIDOLD_ANPHIIDNEW.ContainsKey(dON_MIENANPHI_OLD.ANPHI_ID))
                        {
                            dON_MIENANPH_NEW.ANPHI_ID = MAP_ANPHIIDOLD_ANPHIIDNEW[dON_MIENANPHI_OLD.ANPHI_ID];
                        }

                        dON_MIENANPH_NEW.DONID = oDON_new.ID;
                        dON_MIENANPH_NEW.LOAIAN = 6;
                        dON_MIENANPH_NEW.LYDO = dON_MIENANPHI_OLD.LYDO;
                        dON_MIENANPH_NEW.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dON_MIENANPH_NEW.NGAYTAO = DateTime.Now;
                        dON_MIENANPH_NEW.SOTHONGBAO = dON_MIENANPHI_OLD.SOTHONGBAO;
                        dON_MIENANPH_NEW.NGAYTHONGBAO = dON_MIENANPHI_OLD.NGAYTHONGBAO;
                        dON_MIENANPH_NEW.STB_PHU = dON_MIENANPHI_OLD.STB_PHU;
                        DataExtensions.Insert<DON_MIENANPHI>(dON_MIENANPH_NEW);
                    }
                }

                List<DON_KHAC> dON_KHAC_OLDs = dt.DON_KHAC.Where(x => x.DONID == vDonID && x.LOAIANID == 6 && x.LOAIDON != 7).ToList<DON_KHAC>();
                foreach (DON_KHAC dON_KHAC_OLD in dON_KHAC_OLDs)
                {
                    var dON_KHAC_NEW = new DON_KHAC();
                    dON_KHAC_NEW.DONID = oDON_new.ID;
                    dON_KHAC_NEW.LOAIANID = dON_KHAC_OLD.LOAIANID;
                    dON_KHAC_NEW.TOAANID = dON_KHAC_OLD.TOAANID;
                    dON_KHAC_NEW.LOAIDON = dON_KHAC_OLD.LOAIDON;
                    dON_KHAC_NEW.HINHTHUCNHAN = dON_KHAC_OLD.HINHTHUCNHAN;
                    dON_KHAC_NEW.NGAYVIETDON = dON_KHAC_OLD.NGAYVIETDON;
                    dON_KHAC_NEW.NGAYNHANDON = dON_KHAC_OLD.NGAYNHANDON;
                    dON_KHAC_NEW.CANBONHANDONID = dON_KHAC_OLD.CANBONHANDONID;
                    dON_KHAC_NEW.THAMPHANKYNHANDON = dON_KHAC_OLD.THAMPHANKYNHANDON;
                    dON_KHAC_NEW.NGAYKHANGCAO = dON_KHAC_OLD.NGAYKHANGCAO;
                    if (dON_KHAC_OLD.ISDUONGSU != null && MAP_IDDUONGSUOLD_IDDUONGSUNEW.ContainsKey(dON_KHAC_OLD.DUONGSUID))
                    {
                        dON_KHAC_NEW.DUONGSUID = MAP_IDDUONGSUOLD_IDDUONGSUNEW[dON_KHAC_OLD.DUONGSUID]; // Map id đương sự cũ và mới
                    }

                    dON_KHAC_NEW.LOAIKHANGCAO = dON_KHAC_OLD.LOAIKHANGCAO;
                    dON_KHAC_NEW.SOQDBA = dON_KHAC_OLD.SOQDBA;
                    dON_KHAC_NEW.ISQUAHAN = dON_KHAC_OLD.ISQUAHAN;
                    dON_KHAC_NEW.NGAYQDBA = dON_KHAC_OLD.NGAYQDBA;
                    dON_KHAC_NEW.TOAANRAQDID = dON_KHAC_OLD.TOAANRAQDID;
                    dON_KHAC_NEW.NOIDUNGDON = dON_KHAC_OLD.NOIDUNGDON;
                    dON_KHAC_NEW.ISDUONGSU = dON_KHAC_OLD.ISDUONGSU;
                    dON_KHAC_NEW.TTGQ = dON_KHAC_OLD.TTGQ;
                    dON_KHAC_NEW.NOIDUNGTTGQ = dON_KHAC_OLD.NOIDUNGTTGQ;
                    dON_KHAC_NEW.NOIDUNGKHOIKIEN = dON_KHAC_OLD.NOIDUNGKHOIKIEN;
                    dON_KHAC_NEW.DONGUINHANID = dON_KHAC_OLD.DONGUINHANID;
                    dON_KHAC_NEW.NGAYVIETDONKC = dON_KHAC_OLD.NGAYVIETDONKC;
                    dON_KHAC_NEW.CAPKHANGNGHI = dON_KHAC_OLD.CAPKHANGNGHI;
                    dON_KHAC_NEW.DONVIKHANGNGHI = dON_KHAC_OLD.DONVIKHANGNGHI;
                    dON_KHAC_NEW.LOAIKCKN = dON_KHAC_OLD.LOAIKCKN;
                    dON_KHAC_NEW.SOKHANGNGHI = dON_KHAC_OLD.SOKHANGNGHI;
                    dON_KHAC_NEW.NGUOIKCKN = dON_KHAC_OLD.NGUOIKCKN;
                    dON_KHAC_NEW.NGUOIBIKCKN = dON_KHAC_OLD.NGUOIBIKCKN;
                    dON_KHAC_NEW.NGUOIKCKNLOAI = dON_KHAC_OLD.NGUOIKCKNLOAI;


                    if (dON_KHAC_OLD.TOA_GIAIQUYET_ID != null)
                    {
                        dON_KHAC_NEW.TOA_GIAIQUYET_ID = dON_KHAC_OLD.TOA_GIAIQUYET_ID;
                    }
                    else
                    {
                        dON_KHAC_NEW.TOA_GIAIQUYET_ID = LoginDonViID;
                    }

                    dt.DON_KHAC.Add(dON_KHAC_NEW);
                    dt.SaveChanges();

                }

                //them ma giai doan cap ST
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE_XXLAI_SOTHAM("6", oDON_new.ID, 2, (decimal)LoginDonViID, 0, 0, 0, 0);
            }

        }

        protected void cmdTachan_Click(object sender, EventArgs e)
        {
            decimal vuAnGocId = 0, count = 0;
            AHC_SOTHAM_THULY oNSD = new AHC_SOTHAM_THULY();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    count++;
                    vuAnGocId = Convert.ToDecimal(Item.Cells[0].Text);
                    oNSD = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuAnGocId).FirstOrDefault();
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
                string link = "/QLAN/AHC/Hoso/Popup/pTachAn.aspx?DonID=" + vuAnGocId;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv()");
            }
        }

        protected void cmdNhapan_Click(object sender, EventArgs e)
        {
            decimal vuAnGocId = 0, count = 0;
            AHC_SOTHAM_THULY oNSD = new AHC_SOTHAM_THULY();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    count++;
                    vuAnGocId = Convert.ToDecimal(Item.Cells[0].Text);
                    oNSD = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuAnGocId).FirstOrDefault();
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
                string link = "/QLAN/AHC/Hoso/Popup/pNhapAn.aspx?DonID=" + vuAnGocId;
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

        protected void cmdLoadNhapAn_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Nhập vụ việc thành công!');", true);
            Load_Data();
        }

        //protected void cmdLoadTachAn_Click(object sender, EventArgs e)
        //{
        //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Tách vụ việc thành công!');", true);
        //    Load_Data();
        //}
        protected void ck_GQTDC_QDK_CheckedChanged(object sender, EventArgs e)
        {
            if (Session["CAP_XET_XU"] + "" == "CAPTINH" && ck_GQTDC_QDK.Checked)
            {
                dropCapxx.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
            }
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void DropTINHTRANG_GIAIQUYET_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropTINHTRANG_GIAIQUYET.SelectedValue == "1")
            {
                txtTuNgay.Enabled = false;
            }
            else
            {
                txtTuNgay.Enabled = true;
            }
        }
        #region Check Tìm kiếm theo đơn có Hòa Giải
        protected void checkHG_CheckedChanged(object sender, EventArgs e)
        {
            pnlIsCheckHoaGiai.Visible = checkHG.Checked;
        }
        #endregion Check Tìm kiếm theo đơn có Hòa Giải

        protected void ddlVaiTroThamPhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlVaiTroThamPhan.SelectedValue == ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_HOAGIAI)
            {

                checkHG.Checked = true;
                checkHG_CheckedChanged(this, new EventArgs());
            }
            else
            {
                checkHG.Checked = false;
                checkHG_CheckedChanged(this, new EventArgs());
            }
        }
        #region Danh sách án phí
        protected void lbtDanhSachAnPhi_Click(object sender, EventArgs e)
        {
            string StrMsg = "PopupCenter('/QLAN/pDanhSachAnPhi.aspx?hsID=" + ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.ToString() + "');";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

            //Response.Redirect("CapnhatKetqua.aspx?hsID=" + ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.ToString());
        }
        #endregion

        //Link đến màn danh sách Thống kê quá hạn
        protected void lbtDanhSachQuaHan_Click(object sender, EventArgs e)
        {
            string link = "/QLAN/AHC/Hoso/Popup/pTKQuaHan.aspx";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv()");
        }
    }
}