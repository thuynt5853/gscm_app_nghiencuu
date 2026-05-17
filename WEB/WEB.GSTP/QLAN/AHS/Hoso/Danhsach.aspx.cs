using BL.GSTP;
using BL.GSTP.AHS;
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
using NLog;

namespace WEB.GSTP.QLAN.AHS.Hoso
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        String VuViecTemp = "VuViecIDTemp";
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string strSearch = Session["textsearch"] + "";
                    if (strSearch != "")
                    {
                        txtBiCan.Text = strSearch;
                        Session["textsearch"] = "";
                        LoadDropToaAn();
                        LoadCombobox();
                        Load_Data();
                    }
                    else
                    {
                        //DropTINHTRANG_GIAIQUYET.SelectedValue = "1";
                        Session[VuViecTemp] = "";
                        LoadDropToaAn();
                        LoadCombobox();
                    }

                    string isset = Session[TK_CANHBAO.TK_SET_DEFAULT_VALUE] + "";
                    if (isset == "1")
                    {
                        SetGetSessionTK(false);
                    }


                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        cmdThemmoi.Visible = false;
                    }
                    else
                    {
                        Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                    }
                    if (oPer.ISTHANHNIEN == 1)
                    {
                        ddlLoaiThanhNien.SelectedValue = "1";
                        ddlLoaiThanhNien.Enabled = false;
                    }
                    else if (oPer.ISTHANHNIEN == 2)
                    {
                        ddlLoaiThanhNien.SelectedValue = "2";
                        ddlLoaiThanhNien.Enabled = false;
                    }
                    else
                    {
                        ddlLoaiThanhNien.SelectedValue = "0";
                    }
                    //Load_Data();
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = ex.Message;
                    //ghi log loi
                    logger.Error("loi xay ra: " + ex);
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
            }
        }
        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            ClearSession_TK();
            txtTenVuViec.Text = string.Empty;
            txt_toidanh.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtBiCan.Text = string.Empty;
            dropCapxx.SelectedIndex = -1;
            DropTINHTRANG_THULY.SelectedValue = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSOTHULY.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            Drop_KETQUA.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;
            DropTHOIHAN_GQ.SelectedValue = string.Empty;
            DropQD_TAMGIAM.SelectedValue = string.Empty;
            dropUTTP.SelectedValue = string.Empty;
            ddlLoaiThanhNien.SelectedValue = "0";
            ddlHTXX.SelectedValue = "0";
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
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Kiểm tra cán bộ thuộc tòa án hay là biệt phái
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID && x.TOAANID == ToaAnID).FirstOrDefault<DM_CANBO>();
            DM_CANBO_BIETPHAI oCBBP = dt.DM_CANBO_BIETPHAI.Where(x => x.CANBOID == CanboID && x.TOAANID == ToaAnID).FirstOrDefault<DM_CANBO_BIETPHAI>();
            if (oCB != null)
            {
                //Là cán bộ tòa
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

            if (oCBBP != null)
            {
                //là cán bộ biệt phái
                DM_CANBO CBBP = dt.DM_CANBO.Where(x => x.ID == CanboID && x.TOAANID != ToaAnID).FirstOrDefault<DM_CANBO>();
                // Kiểm tra chức danh có là thẩm phán hay không
                if (CBBP != null)
                    if (CBBP.CHUCDANHID != null && CBBP.CHUCDANHID != 0)
                    {
                        DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == CBBP.CHUCDANHID).FirstOrDefault();
                        if (oCD.MA.Contains("TP"))
                        {
                            ddlThamphan.Items.Add(new ListItem(CBBP.HOTEN, CBBP.ID.ToString()));
                            IsLoadAll = false;
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
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết đơn", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETDON));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết vụ việc", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETVUVIEC));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
            if (ddlThamphan.SelectedValue != null && ddlThamphan.SelectedValue != "")
                ddlVaiTroThamPhan.SelectedValue = ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETVUVIEC;

        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlThamphan.SelectedValue != null && ddlThamphan.SelectedValue != "" && ddlVaiTroThamPhan.SelectedValue == "")
                ddlVaiTroThamPhan.SelectedValue = ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETVUVIEC;
            if (ddlThamphan.SelectedValue == null || ddlThamphan.SelectedValue == "")
                ddlVaiTroThamPhan.SelectedValue = String.Empty;
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
            //Load_Data();
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
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("-- Tất cả --", "0"));
            foreach (DataRow row in tbl.Rows)
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            decimal vchecktk = 0;
            CheckChucDanhUser(ref vchecktk);
            AHS_VUAN_BL obj = new AHS_VUAN_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0,
                isThanhNien = Convert.ToInt32(ddlLoaiThanhNien.SelectedValue),
                isHTXX = Convert.ToInt32(ddlHTXX.SelectedValue),
                isGDTaoHS = Convert.ToInt32(ddlGDTaoHS.SelectedValue);
            DataTable tbl = obj.GetAllPaging(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                            DropTINHTRANG_THULY.SelectedValue, txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                            txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, DropQD_TAMGIAM.SelectedValue, dropUTTP.SelectedValue, vchecktk,
                                            ck_GQTDC_QDK.Checked == true ? 1 : 0, ddlVaiTroThamPhan.SelectedValue, ck_ANKETTHUC.Checked == true ? 1 : 0, pageindex, page_size, isThanhNien, isHTXX, isGDTaoHS);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
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
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
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
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                HiddenField hddCHECK_THULY = (HiddenField)e.Item.FindControl("hddCHECK_THULY");
                Button cmdChitiet = (Button)e.Item.FindControl("cmdChitiet");
                DataRowView dv = (DataRowView)e.Item.DataItem;
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
                //    if(ota.LOAITOA == "CAPHUYEN")
                //    {
                //        cmdChitiet.Enabled = false;//buttondisable
                //        cmdChitiet.CssClass = "buttondisable";
                //        lblSua.Visible = false;
                //        lbtXoa.Visible = false;
                //    }
                //}
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lblSua.Text = "Chi tiết";
                    if (dv["HINHTHUCNHANDON"].ToString() != "998")  // Thu ly lai do GDT hủy để xét xử lại phúc thẩm
                        lbtXoa.Visible = false;
                }
                Button cmdxxlaiPT = (Button)e.Item.FindControl("cmdxxlaiPT");
                Button cmdxxlaiST = (Button)e.Item.FindControl("cmdxxlaiST");
                if (dv["THULYXXLAI"].ToString() == "3") //Da co BA,QD giai doan phúc thẩm moi duoc Thu Ly Xet Xu Lai
                {
                    cmdxxlaiPT.Visible = true;
                    cmdxxlaiST.Visible = false;
                }
                else if (dv["THULYXXLAI"].ToString() == "4") //VNPT HUYLQ Thêm thụ lý xét xử lại ST do GĐT hủy.
                {
                    cmdxxlaiST.Visible = true;
                    cmdxxlaiPT.Visible = false;
                }
                else
                {
                    cmdxxlaiPT.Visible = false;
                    cmdxxlaiST.Visible = false;
                }
            }
        }                                                                                                                                                       
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            decimal IDVuAn = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "xxlaiPT"://Tạo Ho so Xet xu lai Phuc Tham và lựa chọn vụ việc cần Lưu thông tin                  
                    createHoso_xetxulaiPhuctham(IDVuAn);
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "xxlaiST"://Tạo Ho so Xet xu lai So Tham và lựa chọn vụ việc cần Lưu thông tin                  
                    createHoso_xetxulaiSotham(IDVuAn);
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "Select":
                    //Lưu vào người dùng
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                    {
                        oNSD.IDAHINHSU = IDVuAn;
                        dt.SaveChanges();
                    }
                    Session[ENUM_LOAIAN.AN_HINHSU] = IDVuAn;

                    //lưu seccsion thông tin kết thúc vụ án
                    decimal Donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    var gd = dt.AHS_VUAN_GIAIDOAN.AsNoTracking().Where(x => x.VUANID == IDVuAn).ToList();
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

                    Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == IDVuAn).FirstOrDefault();
                    //if (oDon.TOAANID == oNSD.DONVIID && (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT))
                    //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Vụ án đã được chuyển lên cấp trên, các thông tin sẽ không được phép thay đổi !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //else
                    //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Bạn đã chọn vụ án, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "Sua":
                    Response.Redirect("thongtinan.aspx?type=list&ID=" + IDVuAn);
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        //  Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(IDVuAn, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbtthongbao.Text = Result;
                        return;
                    }
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == IDVuAn).FirstOrDefault();
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    var json = new JavaScriptSerializer().Serialize(oT);
                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                    {

                        ADS_DON_BL oBL1 = new ADS_DON_BL();
                        //Luu thong tin ho so vu an khi xoa
                        if (oBL1.HISTORY_ALLDATA_BY_VUANID(IDVuAn, 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Danh sách án Hình sự", "Xóa", json) == false)
                        {
                            lbtthongbao.Text = "Lỗi khi lưu lịch sử khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                        else
                        {
                            lbtthongbao.Text = "Xóa thành công !";
                        }


                        AHS_VUAN_BL oBL = new AHS_VUAN_BL();
                        if (oBL.DELETE_ALLDATA_BY_VUANID(IDVuAn + "") == true)
                        {
                            //anhvh add 26/06/2020
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GIAIDOAN_DELETES("1", IDVuAn, 2);
                        }
                        else
                        {
                            lbtthongbao.Text = "Lỗi khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                    }
                    else
                    {
                        XoaVuAn(IDVuAn);
                    }
                    //để sửa lỗi mất menu khi xóa vụ án, anhvh add trường hợp xóa vụ án và uppdate lại idvuan =0 để giải phóng việc gim vụ án
                    decimal IDUser_ = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD_ = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser_).FirstOrDefault();
                    if (oNSD_.IDAHINHSU == IDVuAn)
                    {
                        oNSD_.IDAHINHSU = 0;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }
        }

        void XoaVuAn(Decimal VuAnID)
        {
            // Kiểm tra người tham gia tố tụng
            AHS_NGUOITHAMGIATOTUNG tgtt = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG>();
            if (tgtt != null)
            {
                lbtthongbao.Text = "Vụ án đã có dữ liệu trong danh sách người tham gia tố tụng, không được phép xóa!";
                return;
            }
            // Kiểm tra biện pháp ngăn chặn
            AHS_SOTHAM_BIENPHAPNGANCHAN bpnc = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_SOTHAM_BIENPHAPNGANCHAN>();
            if (bpnc != null)
            {
                lbtthongbao.Text = "Vụ án đã có biện pháp ngăn chặn, không được phép xóa!";
                return;
            }
            // Kiểm tra bị can, bị cáo
            AHS_BICANBICAO bcbc = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_BICANBICAO>();
            if (bcbc != null)
            {
                lbtthongbao.Text = "Vụ án đã có dữ liệu bị can, bị cáo, không được phép xóa!";
                return;
            }
            List<AHS_FILE> lstF = dt.AHS_FILE.Where(x => x.VUANID == VuAnID).ToList<AHS_FILE>();
            if (lstF.Count > 0)
            {
                foreach (AHS_FILE f in lstF)
                {
                    dt.AHS_FILE.Remove(f);
                }
                dt.SaveChanges();
            }
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            dt.AHS_VUAN.Remove(oT);
            dt.SaveChanges();
            //anhvh add 26/06/2020
            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
            GD.GIAIDOAN_DELETES("1", VuAnID, 2);
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
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
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

        #endregion
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            //---huy vu an da ghim
            Decimal IDVuViec = 0;
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
            oNSD.IDAHINHSU = IDVuViec;
            dt.SaveChanges();
            Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
            Session[VuViecTemp] = "";
            //-----------------------
            Response.Redirect("thongtinan.aspx?type=list");
        }
        private void createHoso_xetxulaiPhuctham(decimal vDonID)
        {
            //Toa Phuc Tham ID
            decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Tao Ho so và Thụ ly Phuc Tham khi GDT huy xet xu lai Phuc Tham
            AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == vDonID).FirstOrDefault();
            if (oDon != null)
            {
                AHS_VUAN oDON_new = new AHS_VUAN();
                oDON_new.TOAANID = oDon.TOAANID;
                oDON_new.VKSID = oDon.VKSID;

                oDON_new.TRUONGHOPGIAONHAN = 998;//an do GDT huy xet xu lai Phuc Tham

                oDON_new.SOBANCAOTRANG = oDon.SOBANCAOTRANG;
                oDON_new.NGAYBANCAOTRANG = oDon.NGAYBANCAOTRANG;
                oDON_new.SOBUTLUC = oDon.SOBUTLUC;
                oDON_new.NGAYGIAO = oDon.NGAYGIAO;
                oDON_new.QUYETDINHTRUYTO = oDon.QUYETDINHTRUYTO;
                oDON_new.MAVUAN = oDon.MAVUAN;
                oDON_new.TENVUAN = oDon.TENVUAN;
                oDON_new.TENKHAC = oDon.TENKHAC;
                oDON_new.SOBICAN = oDon.SOBICAN;
                oDON_new.SOBICANTAMGIAM = oDon.SOBICANTAMGIAM;
                oDON_new.LOAITOIPHAMID = oDon.LOAITOIPHAMID;
                oDON_new.NGAYXAYRA = oDon.NGAYXAYRA;
                oDON_new.THANGXAYRA = oDon.THANGXAYRA;
                oDON_new.NAMXAYRA = oDon.NAMXAYRA;
                oDON_new.GIOXAYRA = oDon.GIOXAYRA;
                oDON_new.GHICHU = oDon.GHICHU;
                oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oDON_new.NGAYTAO = DateTime.Now;
                AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDON_new.TOAAN_CHUYEN_ID = oDon.TOAAN_CHUYEN_ID;
                oDON_new.TRUONGHOPTHULY = oDon.TRUONGHOPTHULY;
                // insert toa_gq_id
                oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;
                // insert toa_pt_gq_id
                oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID = oDon.TOA_PHUCTHAM_GIAIQUYET_ID;
                dt.AHS_VUAN.Add(oDON_new);
                dt.SaveChanges();
                //Session[ENUM_SESSION.SESSION_DONVIID] = oDON_new.TOAANID;
                Session[ENUM_LOAIAN.AN_HINHSU] = oDON_new.ID;

                //Câp dương su vụ án
                List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == vDonID).ToList<AHS_BICANBICAO>();
                foreach (AHS_BICANBICAO vBicao_old in lst)
                {
                    AHS_BICANBICAO vBicao_new = new AHS_BICANBICAO();
                    vBicao_new.VUANID = oDON_new.ID;//ID vuan moi
                    vBicao_new.MABICAN = vBicao_old.MABICAN;
                    vBicao_new.BICANDAUVU = vBicao_old.BICANDAUVU;
                    vBicao_new.HOTEN = vBicao_old.HOTEN;
                    vBicao_new.TENKHAC = vBicao_old.TENKHAC;
                    vBicao_new.NGAYSINH = vBicao_old.NGAYSINH;
                    vBicao_new.THANGSINH = vBicao_old.THANGSINH;
                    vBicao_new.NAMSINH = vBicao_old.NAMSINH;
                    vBicao_new.NGAYTHAMGIA = vBicao_old.NGAYTHAMGIA;
                    vBicao_new.SOCMND = vBicao_old.SOCMND;
                    vBicao_new.TAMTRU = vBicao_old.TAMTRU;
                    vBicao_new.TAMTRUCHITIET = vBicao_old.TAMTRUCHITIET;
                    vBicao_new.HKTT = vBicao_old.HKTT;
                    vBicao_new.KHTTCHITIET = vBicao_old.KHTTCHITIET;
                    vBicao_new.TRINHDOVANHOAID = vBicao_old.TRINHDOVANHOAID;
                    vBicao_new.NGHENGHIEPID = vBicao_old.NGHENGHIEPID;
                    vBicao_new.DANTOCID = vBicao_old.DANTOCID;
                    vBicao_new.QUOCTICHID = vBicao_old.QUOCTICHID;
                    vBicao_new.GIOITINH = vBicao_old.GIOITINH;
                    vBicao_new.TONGIAOID = vBicao_old.TONGIAOID;
                    vBicao_new.NGHIENHUT = vBicao_old.NGHIENHUT;
                    vBicao_new.TAIPHAM = vBicao_old.TAIPHAM;
                    vBicao_new.TIENAN = vBicao_old.TIENAN;
                    vBicao_new.TIENSU = vBicao_old.TIENSU;
                    vBicao_new.TREMOCOI = vBicao_old.TREMOCOI;
                    vBicao_new.BOMELYHON = vBicao_old.BOMELYHON;
                    vBicao_new.TREBOHOC = vBicao_old.TREBOHOC;
                    vBicao_new.TRELANGTHANG = vBicao_old.TRELANGTHANG;
                    vBicao_new.CONGUOIXUIGIUC = vBicao_old.CONGUOIXUIGIUC;
                    vBicao_new.CHUCVUDANGID = vBicao_old.CHUCVUDANGID;
                    vBicao_new.CHUCVUCHINHQUYENID = vBicao_old.CHUCVUCHINHQUYENID;
                    vBicao_new.TINHTRANGGIAMGIUID = vBicao_old.TINHTRANGGIAMGIUID;
                    vBicao_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vBicao_new.NGAYTAO = DateTime.Now;

                    vBicao_new.ISTREVITHANHNIEN = vBicao_old.ISTREVITHANHNIEN;
                    vBicao_new.LOAIDOITUONG = vBicao_old.LOAIDOITUONG;
                    vBicao_new.HKTT_HUYEN = vBicao_old.HKTT_HUYEN;
                    vBicao_new.TAMTRU_HUYEN = vBicao_old.TAMTRU_HUYEN;
                    vBicao_new.TAIPHAMNGUYHIEM = vBicao_old.TAIPHAMNGUYHIEM;
                    vBicao_new.TUOI = vBicao_old.TUOI;
                    vBicao_new.DIACHICOQUAN = vBicao_old.DIACHICOQUAN;
                    vBicao_new.LOAITOIPHAMHS_ID = vBicao_old.LOAITOIPHAMHS_ID;
                    vBicao_new.BICANBICAOID_TACC = vBicao_old.BICANBICAOID_TACC;
                    vBicao_new.TOA_GIAIQUYET_ID = vBicao_old.TOA_GIAIQUYET_ID;

                    dt.AHS_BICANBICAO.Add(vBicao_new);
                    dt.SaveChanges();
                    //Hình phạt bi cao
                    List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lstCaoTrang = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == vBicao_old.ID).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                    foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT vCaoTrang_old in lstCaoTrang)
                    {
                        AHS_SOTHAM_CAOTRANG_DIEULUAT vCaoTrang_new = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                        vCaoTrang_new.BICANID = vBicao_new.ID;// id Bi cao moi
                        vCaoTrang_new.CAOTRANGID = vCaoTrang_old.CAOTRANGID;
                        vCaoTrang_new.DIEULUATID = vCaoTrang_old.DIEULUATID;
                        vCaoTrang_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        vCaoTrang_new.NGAYTAO = DateTime.Now;
                        vCaoTrang_new.TOIDANHID = vCaoTrang_old.TOIDANHID;
                        vCaoTrang_new.VUANID = oDON_new.ID;//ID vuan moi
                        vCaoTrang_new.TENTOIDANH = vCaoTrang_old.TENTOIDANH;
                        vCaoTrang_new.ISMAIN = vCaoTrang_old.ISMAIN;
                        // insert toa_gq_id
                        if (vCaoTrang_new.TOA_GIAIQUYET_ID == null && vCaoTrang_old.TOA_GIAIQUYET_ID != null)
                        {
                            vCaoTrang_new.TOA_GIAIQUYET_ID = vCaoTrang_old.TOA_GIAIQUYET_ID;
                        }
                        dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(vCaoTrang_new);
                        dt.SaveChanges();
                    }
                    //Nhan than bi cao
                    List<AHS_BICAN_NHANTHAN> lstNhanThan = dt.AHS_BICAN_NHANTHAN.Where(x => x.BICANID == vBicao_old.ID && x.VUANID == vDonID).ToList<AHS_BICAN_NHANTHAN>();
                    foreach (AHS_BICAN_NHANTHAN vNhanThan_old in lstNhanThan)
                    {
                        AHS_BICAN_NHANTHAN vNhanThan_new = new AHS_BICAN_NHANTHAN();
                        vNhanThan_new.HOTEN = vNhanThan_old.HOTEN;
                        vNhanThan_new.NGAYSINH = vNhanThan_old.NGAYSINH;
                        vNhanThan_new.NGAYSINH_NAM = vNhanThan_old.NGAYSINH_NAM;
                        vNhanThan_new.MOIQUANHEID = vNhanThan_old.MOIQUANHEID;
                        vNhanThan_new.BICANID = vBicao_new.ID;// id Bi cao moi
                        vNhanThan_new.VUANID = oDON_new.ID;//ID vuan moi
                        vNhanThan_new.QUOCTICHID = vNhanThan_old.QUOCTICHID;
                        vNhanThan_new.GIOITINH = vNhanThan_old.GIOITINH;
                        vNhanThan_new.HKTT_TINH = vNhanThan_old.HKTT_TINH;
                        vNhanThan_new.HKTT_HUYEN = vNhanThan_old.HKTT_HUYEN;
                        vNhanThan_new.HKTT_CHITIET = vNhanThan_old.HKTT_CHITIET;
                        vNhanThan_new.TAMTRU_TINH = vNhanThan_old.TAMTRU_TINH;
                        vNhanThan_new.TAMTRU_HUYEN = vNhanThan_old.TAMTRU_HUYEN;
                        vNhanThan_new.TAMTRU_CHITIET = vNhanThan_old.TAMTRU_CHITIET;
                        vNhanThan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        vNhanThan_new.NGAYTAO = DateTime.Now;
                        vNhanThan_new.GHICHU = vNhanThan_old.GHICHU;
                        dt.AHS_BICAN_NHANTHAN.Add(vNhanThan_new);
                        dt.SaveChanges();
                    }
                    //Bien phap ngan chan cho bi cao
                    List<AHS_SOTHAM_BIENPHAPNGANCHAN> lstBPNC = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.BICANID == vBicao_old.ID && x.VUANID == vDonID).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
                    foreach (AHS_SOTHAM_BIENPHAPNGANCHAN vBPNC_old in lstBPNC)
                    {
                        AHS_SOTHAM_BIENPHAPNGANCHAN vBPNC_new = new AHS_SOTHAM_BIENPHAPNGANCHAN();
                        vBPNC_new.BICANID = vBicao_new.ID;// id Bi cao moi
                        vBPNC_new.DONVIRAQD = vBPNC_old.DONVIRAQD;
                        vBPNC_new.BIENPHAPNGANCHANID = vBPNC_old.BIENPHAPNGANCHANID;
                        vBPNC_new.HIEULUC = vBPNC_old.HIEULUC;
                        vBPNC_new.NGAYBATDAU = vBPNC_old.NGAYBATDAU;
                        vBPNC_new.NGAYKETTHUC = vBPNC_old.NGAYKETTHUC;
                        vBPNC_new.GHICHU = vBPNC_old.GHICHU;
                        vBPNC_new.VUANID = oDON_new.ID;//ID vuan moi
                        vBPNC_new.FILEID = vBPNC_old.FILEID;
                        vBPNC_new.TENFILE = vBPNC_old.TENFILE;
                        vBPNC_new.SOQD = vBPNC_old.SOQD;
                        vBPNC_new.NGAYQD = vBPNC_old.NGAYQD;
                        vBPNC_new.KIEUFILE = vBPNC_old.KIEUFILE;
                        vBPNC_new.NOIDUNGFILE = vBPNC_old.NOIDUNGFILE;
                        vBPNC_new.GIAIDOANAPDUNG = vBPNC_old.GIAIDOANAPDUNG;
                        vBPNC_new.NOIGIAMGIU = vBPNC_old.NOIGIAMGIU;
                        vBPNC_new.NGAYTAO = DateTime.Now;
                        vBPNC_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        if (vBPNC_new.TOA_GIAIQUYET_ID == null && vBPNC_old.TOA_GIAIQUYET_ID != null)
                        {
                            vBPNC_new.TOA_GIAIQUYET_ID = vBPNC_old.TOA_GIAIQUYET_ID;
                        }
                        dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(vBPNC_new);
                        dt.SaveChanges();
                    }
                }
                //Nguoi tham gia to tung

                List<AHS_NGUOITHAMGIATOTUNG> lstNTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == vDonID).ToList<AHS_NGUOITHAMGIATOTUNG>();
                foreach (AHS_NGUOITHAMGIATOTUNG vBNTGTT_old in lstNTGTT)
                {
                    AHS_NGUOITHAMGIATOTUNG vBNTGTT_new = new AHS_NGUOITHAMGIATOTUNG();

                    vBNTGTT_new.VUANID = oDON_new.ID;//ID vuan moi
                    vBNTGTT_new.HOTEN = vBNTGTT_old.HOTEN;
                    vBNTGTT_new.DIACHIID = vBNTGTT_old.DIACHIID;
                    vBNTGTT_new.DIACHICHITIET = vBNTGTT_old.DIACHICHITIET;
                    vBNTGTT_new.GIOITINH = vBNTGTT_old.GIOITINH;
                    vBNTGTT_new.NGAYSINH = vBNTGTT_old.NGAYSINH;
                    vBNTGTT_new.THANGSINH = vBNTGTT_old.THANGSINH;
                    vBNTGTT_new.NAMSINH = vBNTGTT_old.NAMSINH;
                    vBNTGTT_new.NGHENGHIEPID = vBNTGTT_old.NGHENGHIEPID;
                    vBNTGTT_new.CHUCVU = vBNTGTT_old.CHUCVU;
                    vBNTGTT_new.NGAYTHAMGIA = vBNTGTT_old.NGAYTHAMGIA;
                    vBNTGTT_new.NGAYKETTHUC = vBNTGTT_old.NGAYKETTHUC;
                    vBNTGTT_new.GHICHU = vBNTGTT_old.GHICHU;
                    vBNTGTT_new.ISHOSO = vBNTGTT_old.ISHOSO;
                    vBNTGTT_new.ISSOTHAM = vBNTGTT_old.ISSOTHAM;
                    vBNTGTT_new.ISPHUCTHAM = vBNTGTT_old.ISPHUCTHAM;
                    vBNTGTT_new.ISTREVITHANHNIEN = vBNTGTT_old.ISTREVITHANHNIEN;
                    vBNTGTT_new.LOAITREVITHANHNIEN = vBNTGTT_old.LOAITREVITHANHNIEN;
                    vBNTGTT_new.LOAIDT = vBNTGTT_old.LOAIDT;
                    vBNTGTT_new.NDD_HOTEN = vBNTGTT_old.NDD_HOTEN;
                    vBNTGTT_new.NDD_CHUCVU = vBNTGTT_old.NDD_CHUCVU;
                    vBNTGTT_new.NDD_CMND = vBNTGTT_old.NDD_CMND;
                    vBNTGTT_new.NDD_MOBILE = vBNTGTT_old.NDD_MOBILE;
                    vBNTGTT_new.NDD_EMAIL = vBNTGTT_old.NDD_EMAIL;
                    vBNTGTT_new.FILEID = vBNTGTT_old.FILEID;
                    vBNTGTT_new.NGAYSUA = DateTime.Now;
                    vBNTGTT_new.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vBNTGTT_new.ID_NGUOITGTT_QLTACC = vBNTGTT_old.ID_NGUOITGTT_QLTACC;
                    // insert toa_gq_id
                    if (vBNTGTT_new.TOA_GIAIQUYET_ID == null && vBNTGTT_old.TOA_GIAIQUYET_ID != null)
                    {
                        vBNTGTT_new.TOA_GIAIQUYET_ID = vBNTGTT_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHS_NGUOITHAMGIATOTUNG.Add(vBNTGTT_new);
                    dt.SaveChanges();
                }
                //Luu thong tin Bản án Quyết định
                List<AHS_SOTHAM_BANAN> lstBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == vDonID).ToList<AHS_SOTHAM_BANAN>();
                foreach (AHS_SOTHAM_BANAN vBA_old in lstBA)
                {
                    AHS_SOTHAM_BANAN vBA_new = new AHS_SOTHAM_BANAN();
                    vBA_new.VUANID = oDON_new.ID;//ID vuan moi
                    vBA_new.TOAANID = vBA_old.TOAANID;
                    vBA_new.SOBANAN = vBA_old.SOBANAN;
                    vBA_new.NGAYBANAN = vBA_old.NGAYBANAN;
                    vBA_new.NGAYMOPHIENTOA = vBA_old.NGAYMOPHIENTOA;
                    vBA_new.DIADIEM = vBA_old.DIADIEM;
                    vBA_new.ISXXLUUDONG = vBA_old.ISXXLUUDONG;
                    vBA_new.ISBAOLUCGIADINH = vBA_old.ISBAOLUCGIADINH;
                    vBA_new.ISANDIEM = vBA_old.ISANDIEM;
                    vBA_new.ISANRUTGON = vBA_old.ISANRUTGON;
                    vBA_new.ISANLE = vBA_old.ISANLE;
                    vBA_new.THONGTINTHIETHAI = vBA_old.THONGTINTHIETHAI;
                    vBA_new.SOBICAO_KHOAN_KHACVKS = vBA_old.SOBICAO_KHOAN_KHACVKS;
                    vBA_new.SOBICAO_DIEU_KHACVKS = vBA_old.SOBICAO_DIEU_KHACVKS;
                    vBA_new.SOBICAO_MUC_KHACVKS = vBA_old.SOBICAO_MUC_KHACVKS;
                    vBA_new.GHICHU = vBA_old.GHICHU;
                    vBA_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vBA_new.NGAYTAO = DateTime.Now;
                    vBA_new.TENFILE = vBA_old.TENFILE;
                    vBA_new.KIEUFILE = vBA_old.KIEUFILE;
                    vBA_new.NOIDUNGFILE = vBA_old.NOIDUNGFILE;
                    vBA_new.NGAYKY = vBA_old.NGAYKY;
                    vBA_new.NGUOIKY = vBA_old.NGUOIKY;
                    vBA_new.TK_TSCHIEMDOAT = vBA_old.TK_TSCHIEMDOAT;
                    vBA_new.TK_TSTHIETHAI = vBA_old.TK_TSTHIETHAI;
                    vBA_new.TK_ISVIPHAMHANTAMGIAM = vBA_old.TK_ISVIPHAMHANTAMGIAM;
                    vBA_new.TK_VIPHAMTG_BICAO = vBA_old.TK_VIPHAMTG_BICAO;
                    vBA_new.TK_PHUCHOIAN_VUAN = vBA_old.TK_PHUCHOIAN_VUAN;
                    vBA_new.TK_PHUCHOIAN_BICAO = vBA_old.TK_PHUCHOIAN_BICAO;
                    vBA_new.TK_TOAAN_SOVUXM = vBA_old.TK_TOAAN_SOVUXM;
                    vBA_new.TK_TOAAN_KOXM = vBA_old.TK_TOAAN_KOXM;
                    vBA_new.TK_KHOITO_VUAN = vBA_old.TK_KHOITO_VUAN;
                    vBA_new.TK_KHOITO_BICAO = vBA_old.TK_KHOITO_BICAO;
                    vBA_new.TK_QUAHAN_KHACHQUAN = vBA_old.TK_QUAHAN_KHACHQUAN;
                    vBA_new.TK_QUAHAN_CHUQUAN = vBA_old.TK_QUAHAN_CHUQUAN;
                    vBA_new.TK_ISTRAHS_VKSKHONGNHAN = vBA_old.TK_ISTRAHS_VKSKHONGNHAN;
                    vBA_new.TK_YEUCAUVKSBOSUNGTL = vBA_old.TK_YEUCAUVKSBOSUNGTL;
                    vBA_new.TK_VIPHAMCONGTACQL = vBA_old.TK_VIPHAMCONGTACQL;
                    vBA_new.TK_XXKHACVKS_TOIDANH_NANGHON = vBA_old.TK_XXKHACVKS_TOIDANH_NANGHON;
                    vBA_new.TK_XXKHACVKS_KHOAN_NANGHON = vBA_old.TK_XXKHACVKS_KHOAN_NANGHON;
                    vBA_new.TK_XXKHACVKS_KHOAN_NHEHON = vBA_old.TK_XXKHACVKS_KHOAN_NHEHON;
                    vBA_new.TK_XXKHACVKS_HINHPHAT_NANGHON = vBA_old.TK_XXKHACVKS_HINHPHAT_NANGHON;
                    vBA_new.TK_XXKHACVKS_HINHPHAT_NHEHON = vBA_old.TK_XXKHACVKS_HINHPHAT_NHEHON;
                    vBA_new.TK_XXKHACVKS_TOIDANH_NHEHON = vBA_old.TK_XXKHACVKS_TOIDANH_NHEHON;
                    vBA_new.TK_KIENNGHIHUYVBTRAIPL = vBA_old.TK_KIENNGHIHUYVBTRAIPL;
                    vBA_new.TK_PNTM_NHANUOC = vBA_old.TK_PNTM_NHANUOC;
                    vBA_new.TK_PNTM_NUOCNGOAI = vBA_old.TK_PNTM_NUOCNGOAI;
                    vBA_new.TK_APDUNGBAOVE = vBA_old.TK_APDUNGBAOVE;
                    vBA_new.FILEID = vBA_old.FILEID;
                    vBA_new.SOBUTLUC = vBA_old.SOBUTLUC;
                    // insert toa_gq_id
                    if (vBA_new.TOA_GIAIQUYET_ID == null && vBA_old.TOA_GIAIQUYET_ID != null)
                    {
                        vBA_new.TOA_GIAIQUYET_ID = vBA_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHS_SOTHAM_BANAN.Add(vBA_new);
                    dt.SaveChanges();
                }
                //Luu thong tin Quyet dinh
                List<AHS_SOTHAM_QUYETDINH_VUAN> lstQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == vDonID).ToList<AHS_SOTHAM_QUYETDINH_VUAN>();
                foreach (AHS_SOTHAM_QUYETDINH_VUAN vQD_old in lstQD)
                {
                    AHS_SOTHAM_QUYETDINH_VUAN vQD_new = new AHS_SOTHAM_QUYETDINH_VUAN();
                    vQD_new.LOAIQDID = vQD_old.LOAIQDID;
                    vQD_new.QUYETDINHID = vQD_old.QUYETDINHID;
                    vQD_new.LOAIDONVI = vQD_old.LOAIDONVI;
                    vQD_new.DONVIID = vQD_old.DONVIID;
                    vQD_new.SOQUYETDINH = vQD_old.SOQUYETDINH;
                    vQD_new.NGAYQD = vQD_old.NGAYQD;
                    vQD_new.HIEULUCTU = vQD_old.HIEULUCTU;
                    vQD_new.THEOLUAT_THANG = vQD_old.THEOLUAT_THANG;
                    vQD_new.THEOLUAT_NGAY = vQD_old.THEOLUAT_NGAY;
                    vQD_new.THEOLUAT_NGAYKETTHUC = vQD_old.THEOLUAT_NGAYKETTHUC;
                    vQD_new.THUCTE_THANG = vQD_old.THUCTE_THANG;
                    vQD_new.THUCTE_NGAY = vQD_old.THUCTE_NGAY;
                    vQD_new.THUCTE_NGAYKETTHUC = vQD_old.THUCTE_NGAYKETTHUC;
                    vQD_new.NGUOIKYID = vQD_old.NGUOIKYID;
                    vQD_new.CHUCVU = vQD_old.CHUCVU;
                    vQD_new.GHICHU = vQD_old.GHICHU;
                    vQD_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vQD_new.NGAYTAO = DateTime.Now;
                    vQD_new.TENFILE = vQD_old.TENFILE;
                    vQD_new.KIEUFILE = vQD_old.KIEUFILE;
                    vQD_new.NOIDUNGFILE = vQD_old.NOIDUNGFILE;
                    vQD_new.VUANID = oDON_new.ID;//ID vuan moi
                    vQD_new.HIEULUCDEN = vQD_old.HIEULUCDEN;
                    vQD_new.LYDOID = vQD_old.LYDOID;
                    vQD_new.FILEID = vQD_old.FILEID;
                    vQD_new.THAYDOITCTT = vQD_old.THAYDOITCTT;
                    vQD_new.NGUOIDUOCPHANCONG = vQD_old.NGUOIDUOCPHANCONG;
                    vQD_new.NGUOIBITHAY = vQD_old.NGUOIBITHAY;
                    vQD_new.NGAYMOPT = vQD_old.NGAYMOPT;
                    vQD_new.DIADIEMMOPT = vQD_old.DIADIEMMOPT;
                    vQD_new.LYDO_NAME = vQD_old.LYDO_NAME;
                    vQD_new.HINHTHUCXETXU = vQD_old.HINHTHUCXETXU;
                    // insert toa_gq_id
                    if (vQD_new.TOA_GIAIQUYET_ID == null && vQD_old.TOA_GIAIQUYET_ID != null)
                    {
                        vQD_new.TOA_GIAIQUYET_ID = vQD_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHS_SOTHAM_QUYETDINH_VUAN.Add(vQD_new);
                    dt.SaveChanges();
                }

                //lưu Tội danh cáo trang
                //Lưu thông tin kháng cáo kháng nghị AHS_SOTHAM_KHANGCAO AHS_SOTHAM_KHANGNGHI
                List<AHS_SOTHAM_KHANGCAO> lstKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == vDonID).ToList<AHS_SOTHAM_KHANGCAO>();
                foreach (AHS_SOTHAM_KHANGCAO vKC_old in lstKC)
                {
                    AHS_SOTHAM_KHANGCAO vKC_new = new AHS_SOTHAM_KHANGCAO();

                    vKC_new.VUANID = oDON_new.ID;//ID vuan moi
                    vKC_new.NGUOIKCLOAI = vKC_old.NGUOIKCLOAI;
                    vKC_new.NGAYVIETDON = vKC_old.NGAYVIETDON;
                    vKC_new.NGAYKHANGCAO = vKC_old.NGAYKHANGCAO;
                    vKC_new.NGUOIKCID = vKC_old.NGUOIKCID;
                    vKC_new.LOAIKHANGCAO = vKC_old.LOAIKHANGCAO;
                    vKC_new.SOQDBA = vKC_old.SOQDBA;
                    vKC_new.ISQUAHAN = vKC_old.ISQUAHAN;
                    vKC_new.NGAYQDBA = vKC_old.NGAYQDBA;
                    vKC_new.TOAANRAQDID = vKC_old.TOAANRAQDID;
                    vKC_new.ISMIENANPHI = vKC_old.ISMIENANPHI;
                    vKC_new.ANPHI = vKC_old.ANPHI;
                    vKC_new.SOBIENLAI = vKC_old.SOBIENLAI;
                    vKC_new.NGAYNOPANPHI = vKC_old.NGAYNOPANPHI;
                    vKC_new.GQ_NGAY = vKC_old.GQ_NGAY;
                    vKC_new.GQ_THAMPHANID = vKC_old.GQ_THAMPHANID;
                    vKC_new.GQ_ISCHAPNHAN = vKC_old.GQ_ISCHAPNHAN;
                    vKC_new.GQ_GHICHU = vKC_old.GQ_GHICHU;
                    vKC_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vKC_new.NGAYTAO = DateTime.Now;
                    vKC_new.TENFILE = vKC_old.TENFILE;
                    vKC_new.KIEUFILE = vKC_old.KIEUFILE;
                    vKC_new.NOIDUNGFILE = vKC_old.NOIDUNGFILE;
                    vKC_new.GQ_TINHTRANG = vKC_old.GQ_TINHTRANG;
                    vKC_new.GQ_TOAANID = vKC_old.GQ_TOAANID;
                    vKC_new.GQ_THAMPHANID_1 = vKC_old.GQ_THAMPHANID_1;
                    vKC_new.GQ_THAMPHANID_2 = vKC_old.GQ_THAMPHANID_2;
                    vKC_new.NOIDUNGKHANGCAO = vKC_old.NOIDUNGKHANGCAO;
                    vKC_new.DSNGUOIBIKC = vKC_old.DSNGUOIBIKC;
                    // insert toa_gq_id
                    if (vKC_new.TOA_GIAIQUYET_ID == null && vKC_old.TOA_GIAIQUYET_ID != null)
                    {
                        vKC_new.TOA_GIAIQUYET_ID = vKC_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHS_SOTHAM_KHANGCAO.Add(vKC_new);
                    dt.SaveChanges();
                }
                List<AHS_SOTHAM_KHANGNGHI> lstKN = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == vDonID).ToList<AHS_SOTHAM_KHANGNGHI>();
                foreach (AHS_SOTHAM_KHANGNGHI vKN_old in lstKN)
                {
                    AHS_SOTHAM_KHANGNGHI vKN_new = new AHS_SOTHAM_KHANGNGHI();

                    vKN_new.VUANID = oDON_new.ID;//ID vuan moi
                    vKN_new.SOKN = vKN_old.SOKN;
                    vKN_new.NGAYKN = vKN_old.NGAYKN;
                    vKN_new.DONVIKN = vKN_old.DONVIKN;
                    vKN_new.CAPKN = vKN_old.CAPKN;
                    vKN_new.LOAIKN = vKN_old.LOAIKN;
                    vKN_new.BANANID = vKN_old.BANANID;
                    vKN_new.NGAYBANAN = vKN_old.NGAYBANAN;
                    vKN_new.TOAANRAQDID = vKN_old.TOAANRAQDID;
                    vKN_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vKN_new.NGAYTAO = DateTime.Now;
                    vKN_new.TENFILE = vKN_old.TENFILE;
                    vKN_new.KIEUFILE = vKN_old.KIEUFILE;
                    vKN_new.NOIDUNGFILE = vKN_old.NOIDUNGFILE;
                    vKN_new.TOAAN_VKS_KN = vKN_old.TOAAN_VKS_KN;
                    vKN_new.NOIDUNGKN = vKN_old.NOIDUNGKN;
                    vKN_new.DSNGUOIBIKN = vKN_old.DSNGUOIBIKN;
                    // insert toa_gq_id
                    if (vKN_new.TOA_GIAIQUYET_ID == null && vKN_old.TOA_GIAIQUYET_ID != null)
                    {
                        vKN_new.TOA_GIAIQUYET_ID = vKN_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHS_SOTHAM_KHANGNGHI.Add(vKN_new);
                    dt.SaveChanges();
                }
                //Lưu thông tin chuyển nhận án
                //AHS_CHUYEN_NHAN_AN
                List<AHS_CHUYEN_NHAN_AN> lstCN = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == vDonID).ToList<AHS_CHUYEN_NHAN_AN>();
                foreach (AHS_CHUYEN_NHAN_AN vCN_old in lstCN)
                {
                    AHS_CHUYEN_NHAN_AN vCN_new = new AHS_CHUYEN_NHAN_AN();

                    vCN_new.VUANID = oDON_new.ID;//ID vuan moi
                    vCN_new.TOACHUYENID = vCN_old.TOACHUYENID;
                    vCN_new.TOANHANID = vCN_old.TOANHANID;
                    vCN_new.NGAYGIAO = vCN_old.NGAYGIAO;
                    //vCN_new.TRUONGHOPGIAONHANID = vCN_old.TRUONGHOPGIAONHANID;
                    vCN_new.TRUONGHOPGIAONHANID = 998;
                    vCN_new.NGUOIGIAOID = vCN_old.NGUOIGIAOID;
                    vCN_new.GHICHU_GIAO = vCN_old.GHICHU_GIAO;
                    vCN_new.NGAYNHAN = vCN_old.NGAYNHAN;
                    vCN_new.NGUOINHANID = vCN_old.NGUOINHANID;
                    vCN_new.TRANGTHAI = vCN_old.TRANGTHAI;
                    vCN_new.NGAYTAO = DateTime.Now;
                    vCN_new.MAP_VUANID_NEW = vCN_old.MAP_VUANID_NEW;
                    vCN_new.SOBUTLUC = vCN_old.SOBUTLUC;
                    if (vCN_new.TOA_GIAIQUYET_ID == null && vCN_old.TOA_GIAIQUYET_ID != null)
                    {
                        vCN_new.TOA_GIAIQUYET_ID = vCN_old.TOA_GIAIQUYET_ID;
                    }
                    dt.AHS_CHUYEN_NHAN_AN.Add(vCN_new);
                    dt.SaveChanges();
                }

                //them ma giai doan cap Phuc tham 
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE_XXLAI_PHUCTHAM("1", oDON_new.ID, 3, (decimal)oDON_new.TOAANID, LoginDonViID, 0, 0, 0);
                //ket thuc OK
            }

        }

        private void createHoso_xetxulaiSotham(decimal vDonID)
        {
            //Toa So tham ID
            decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Tao Ho so và Thụ ly So Tham khi GDT huy xet xu lai So Tham
            AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == vDonID).FirstOrDefault();
            if (oDon != null)
            {
                AHS_VUAN oDON_new = new AHS_VUAN();
                oDON_new.TOAANID = oDon.TOAANID;
                oDON_new.VKSID = oDon.VKSID;

                oDON_new.TRUONGHOPGIAONHAN = 2597;//an do GDT huy xet xu lai So Tham 

                oDON_new.SOBANCAOTRANG = oDon.SOBANCAOTRANG;
                oDON_new.NGAYBANCAOTRANG = oDon.NGAYBANCAOTRANG;
                oDON_new.SOBUTLUC = oDon.SOBUTLUC;
                oDON_new.NGAYGIAO = oDon.NGAYGIAO;
                oDON_new.QUYETDINHTRUYTO = oDon.QUYETDINHTRUYTO;
                oDON_new.MAVUAN = oDon.MAVUAN;
                oDON_new.TENVUAN = oDon.TENVUAN;
                oDON_new.TENKHAC = oDon.TENKHAC;
                oDON_new.SOBICAN = oDon.SOBICAN;
                oDON_new.SOBICANTAMGIAM = oDon.SOBICANTAMGIAM;
                oDON_new.LOAITOIPHAMID = oDon.LOAITOIPHAMID;
                oDON_new.NGAYXAYRA = oDon.NGAYXAYRA;
                oDON_new.THANGXAYRA = oDon.THANGXAYRA;
                oDON_new.NAMXAYRA = oDon.NAMXAYRA;
                oDON_new.GIOXAYRA = oDon.GIOXAYRA;
                oDON_new.GHICHU = oDon.GHICHU;
                oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oDON_new.NGAYTAO = DateTime.Now;
                AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDON_new.TOAAN_CHUYEN_ID = oDon.TOAAN_CHUYEN_ID;
                oDON_new.TRUONGHOPTHULY = oDon.TRUONGHOPTHULY;
                // insert toa_gq_id
                oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;
                // insert toa_pt_gq_id
                oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID = oDon.TOA_PHUCTHAM_GIAIQUYET_ID;
                dt.AHS_VUAN.Add(oDON_new);
                dt.SaveChanges();
                //Session[ENUM_SESSION.SESSION_DONVIID] = oDON_new.TOAANID;
                Session[ENUM_LOAIAN.AN_HINHSU] = oDON_new.ID;

                Dictionary<decimal?, decimal?> mapDUONGSUIDOLD_NEW = new Dictionary<decimal?, decimal?>();

                Dictionary<decimal?, decimal?> mapNTGTOTUNGOLD_NEW = new Dictionary<decimal?, decimal?>();

                //Câp dương su vụ án
                List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == vDonID).ToList<AHS_BICANBICAO>();
                foreach (AHS_BICANBICAO vBicao_old in lst)
                {
                    AHS_BICANBICAO vBicao_new = new AHS_BICANBICAO();
                    vBicao_new.VUANID = oDON_new.ID;//ID vuan moi
                    vBicao_new.MABICAN = vBicao_old.MABICAN;
                    vBicao_new.BICANDAUVU = vBicao_old.BICANDAUVU;
                    vBicao_new.HOTEN = vBicao_old.HOTEN;
                    vBicao_new.TENKHAC = vBicao_old.TENKHAC;
                    vBicao_new.NGAYSINH = vBicao_old.NGAYSINH;
                    vBicao_new.THANGSINH = vBicao_old.THANGSINH;
                    vBicao_new.NAMSINH = vBicao_old.NAMSINH;
                    vBicao_new.NGAYTHAMGIA = vBicao_old.NGAYTHAMGIA;
                    vBicao_new.SOCMND = vBicao_old.SOCMND;
                    vBicao_new.TAMTRU = vBicao_old.TAMTRU;
                    vBicao_new.TAMTRUCHITIET = vBicao_old.TAMTRUCHITIET;
                    vBicao_new.HKTT = vBicao_old.HKTT;
                    vBicao_new.KHTTCHITIET = vBicao_old.KHTTCHITIET;
                    vBicao_new.TRINHDOVANHOAID = vBicao_old.TRINHDOVANHOAID;
                    vBicao_new.NGHENGHIEPID = vBicao_old.NGHENGHIEPID;
                    vBicao_new.DANTOCID = vBicao_old.DANTOCID;
                    vBicao_new.QUOCTICHID = vBicao_old.QUOCTICHID;
                    vBicao_new.GIOITINH = vBicao_old.GIOITINH;
                    vBicao_new.TONGIAOID = vBicao_old.TONGIAOID;
                    vBicao_new.NGHIENHUT = vBicao_old.NGHIENHUT;
                    vBicao_new.TAIPHAM = vBicao_old.TAIPHAM;
                    vBicao_new.TIENAN = vBicao_old.TIENAN;
                    vBicao_new.TIENSU = vBicao_old.TIENSU;
                    vBicao_new.TREMOCOI = vBicao_old.TREMOCOI;
                    vBicao_new.BOMELYHON = vBicao_old.BOMELYHON;
                    vBicao_new.TREBOHOC = vBicao_old.TREBOHOC;
                    vBicao_new.TRELANGTHANG = vBicao_old.TRELANGTHANG;
                    vBicao_new.CONGUOIXUIGIUC = vBicao_old.CONGUOIXUIGIUC;
                    vBicao_new.CHUCVUDANGID = vBicao_old.CHUCVUDANGID;
                    vBicao_new.CHUCVUCHINHQUYENID = vBicao_old.CHUCVUCHINHQUYENID;
                    vBicao_new.TINHTRANGGIAMGIUID = vBicao_old.TINHTRANGGIAMGIUID;
                    vBicao_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vBicao_new.NGAYTAO = DateTime.Now;

                    vBicao_new.ISTREVITHANHNIEN = vBicao_old.ISTREVITHANHNIEN;
                    vBicao_new.LOAIDOITUONG = vBicao_old.LOAIDOITUONG;
                    vBicao_new.HKTT_HUYEN = vBicao_old.HKTT_HUYEN;
                    vBicao_new.TAMTRU_HUYEN = vBicao_old.TAMTRU_HUYEN;
                    vBicao_new.TAIPHAMNGUYHIEM = vBicao_old.TAIPHAMNGUYHIEM;
                    vBicao_new.TUOI = vBicao_old.TUOI;
                    vBicao_new.DIACHICOQUAN = vBicao_old.DIACHICOQUAN;
                    vBicao_new.LOAITOIPHAMHS_ID = vBicao_old.LOAITOIPHAMHS_ID;
                    vBicao_new.BICANBICAOID_TACC = vBicao_old.BICANBICAOID_TACC;
                    vBicao_new.SO_CCCD = vBicao_old.SO_CCCD;
                    vBicao_new.SO_HOCHIEU = vBicao_old.SO_HOCHIEU;
                    vBicao_new.CHK_KHONG_CO = vBicao_old.CHK_KHONG_CO;
                    vBicao_new.XACTHUC_DLDCQG = vBicao_old.XACTHUC_DLDCQG;

                    if (vBicao_old.TOA_GIAIQUYET_ID != null)
                    {
                        vBicao_new.TOA_GIAIQUYET_ID = vBicao_old.TOA_GIAIQUYET_ID;
                    }
                    else
                    {
                        vBicao_new.TOA_GIAIQUYET_ID = LoginDonViID;
                    }

                    dt.AHS_BICANBICAO.Add(vBicao_new);
                    dt.SaveChanges();

                    mapDUONGSUIDOLD_NEW[vBicao_old.ID] = vBicao_new.ID;
                    //Hình phạt bi cao
                    List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lstCaoTrang = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == vBicao_old.ID).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                    foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT vCaoTrang_old in lstCaoTrang)
                    {
                        AHS_SOTHAM_CAOTRANG_DIEULUAT vCaoTrang_new = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                        vCaoTrang_new.BICANID = vBicao_new.ID;// id Bi cao moi
                        vCaoTrang_new.CAOTRANGID = vCaoTrang_old.CAOTRANGID;
                        vCaoTrang_new.DIEULUATID = vCaoTrang_old.DIEULUATID;
                        vCaoTrang_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        vCaoTrang_new.NGAYTAO = DateTime.Now;
                        vCaoTrang_new.TOIDANHID = vCaoTrang_old.TOIDANHID;
                        vCaoTrang_new.VUANID = oDON_new.ID;//ID vuan moi
                        vCaoTrang_new.TENTOIDANH = vCaoTrang_old.TENTOIDANH;
                        vCaoTrang_new.ISMAIN = vCaoTrang_old.ISMAIN;
                        // insert toa_gq_id
                        if (vCaoTrang_new.TOA_GIAIQUYET_ID == null && vCaoTrang_old.TOA_GIAIQUYET_ID != null)
                        {
                            vCaoTrang_new.TOA_GIAIQUYET_ID = vCaoTrang_old.TOA_GIAIQUYET_ID;
                        }
                        else
                        {
                            vCaoTrang_new.TOA_GIAIQUYET_ID = LoginDonViID;
                        }
                        dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(vCaoTrang_new);
                        dt.SaveChanges();
                    }
                    //Nhan than bi cao
                    List<AHS_BICAN_NHANTHAN> lstNhanThan = dt.AHS_BICAN_NHANTHAN.Where(x => x.BICANID == vBicao_old.ID && x.VUANID == vDonID).ToList<AHS_BICAN_NHANTHAN>();
                    foreach (AHS_BICAN_NHANTHAN vNhanThan_old in lstNhanThan)
                    {
                        AHS_BICAN_NHANTHAN vNhanThan_new = new AHS_BICAN_NHANTHAN();
                        vNhanThan_new.HOTEN = vNhanThan_old.HOTEN;
                        vNhanThan_new.NGAYSINH = vNhanThan_old.NGAYSINH;
                        vNhanThan_new.NGAYSINH_NAM = vNhanThan_old.NGAYSINH_NAM;
                        vNhanThan_new.MOIQUANHEID = vNhanThan_old.MOIQUANHEID;
                        vNhanThan_new.BICANID = vBicao_new.ID;// id Bi cao moi
                        vNhanThan_new.VUANID = oDON_new.ID;//ID vuan moi
                        vNhanThan_new.QUOCTICHID = vNhanThan_old.QUOCTICHID;
                        vNhanThan_new.GIOITINH = vNhanThan_old.GIOITINH;
                        vNhanThan_new.HKTT_TINH = vNhanThan_old.HKTT_TINH;
                        vNhanThan_new.HKTT_HUYEN = vNhanThan_old.HKTT_HUYEN;
                        vNhanThan_new.HKTT_CHITIET = vNhanThan_old.HKTT_CHITIET;
                        vNhanThan_new.TAMTRU_TINH = vNhanThan_old.TAMTRU_TINH;
                        vNhanThan_new.TAMTRU_HUYEN = vNhanThan_old.TAMTRU_HUYEN;
                        vNhanThan_new.TAMTRU_CHITIET = vNhanThan_old.TAMTRU_CHITIET;
                        vNhanThan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        vNhanThan_new.NGAYTAO = DateTime.Now;
                        vNhanThan_new.GHICHU = vNhanThan_old.GHICHU;
                        dt.AHS_BICAN_NHANTHAN.Add(vNhanThan_new);
                        dt.SaveChanges();
                    }
                    //Bien phap ngan chan cho bi cao
                    List<AHS_SOTHAM_BIENPHAPNGANCHAN> lstBPNC = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.BICANID == vBicao_old.ID && x.VUANID == vDonID).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
                    foreach (AHS_SOTHAM_BIENPHAPNGANCHAN vBPNC_old in lstBPNC)
                    {
                        AHS_SOTHAM_BIENPHAPNGANCHAN vBPNC_new = new AHS_SOTHAM_BIENPHAPNGANCHAN();
                        vBPNC_new.BICANID = vBicao_new.ID;// id Bi cao moi
                        vBPNC_new.DONVIRAQD = vBPNC_old.DONVIRAQD;
                        vBPNC_new.BIENPHAPNGANCHANID = vBPNC_old.BIENPHAPNGANCHANID;
                        vBPNC_new.HIEULUC = vBPNC_old.HIEULUC;
                        vBPNC_new.NGAYBATDAU = vBPNC_old.NGAYBATDAU;
                        vBPNC_new.NGAYKETTHUC = vBPNC_old.NGAYKETTHUC;
                        vBPNC_new.GHICHU = vBPNC_old.GHICHU;
                        vBPNC_new.VUANID = oDON_new.ID;//ID vuan moi
                        vBPNC_new.FILEID = vBPNC_old.FILEID;
                        vBPNC_new.TENFILE = vBPNC_old.TENFILE;
                        vBPNC_new.SOQD = vBPNC_old.SOQD;
                        vBPNC_new.NGAYQD = vBPNC_old.NGAYQD;
                        vBPNC_new.KIEUFILE = vBPNC_old.KIEUFILE;
                        vBPNC_new.NOIDUNGFILE = vBPNC_old.NOIDUNGFILE;
                        vBPNC_new.GIAIDOANAPDUNG = vBPNC_old.GIAIDOANAPDUNG;
                        vBPNC_new.NOIGIAMGIU = vBPNC_old.NOIGIAMGIU;
                        vBPNC_new.NGAYTAO = DateTime.Now;
                        vBPNC_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        if (vBPNC_new.TOA_GIAIQUYET_ID == null && vBPNC_old.TOA_GIAIQUYET_ID != null)
                        {
                            vBPNC_new.TOA_GIAIQUYET_ID = vBPNC_old.TOA_GIAIQUYET_ID;
                        }
                        else
                        {
                            vBPNC_new.TOA_GIAIQUYET_ID = LoginDonViID;
                        }
                        dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(vBPNC_new);
                        dt.SaveChanges();
                    }
                }
                //Nguoi tham gia to tung

                List<AHS_NGUOITHAMGIATOTUNG> lstNTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == vDonID).ToList<AHS_NGUOITHAMGIATOTUNG>();
                foreach (AHS_NGUOITHAMGIATOTUNG vBNTGTT_old in lstNTGTT)
                {
                    AHS_NGUOITHAMGIATOTUNG vBNTGTT_new = new AHS_NGUOITHAMGIATOTUNG();

                    vBNTGTT_new.VUANID = oDON_new.ID;//ID vuan moi
                    vBNTGTT_new.HOTEN = vBNTGTT_old.HOTEN;
                    vBNTGTT_new.DIACHIID = vBNTGTT_old.DIACHIID;
                    vBNTGTT_new.DIACHICHITIET = vBNTGTT_old.DIACHICHITIET;
                    vBNTGTT_new.GIOITINH = vBNTGTT_old.GIOITINH;
                    vBNTGTT_new.NGAYSINH = vBNTGTT_old.NGAYSINH;
                    vBNTGTT_new.THANGSINH = vBNTGTT_old.THANGSINH;
                    vBNTGTT_new.NAMSINH = vBNTGTT_old.NAMSINH;
                    vBNTGTT_new.NGHENGHIEPID = vBNTGTT_old.NGHENGHIEPID;
                    vBNTGTT_new.CHUCVU = vBNTGTT_old.CHUCVU;
                    vBNTGTT_new.NGAYTHAMGIA = vBNTGTT_old.NGAYTHAMGIA;
                    vBNTGTT_new.NGAYKETTHUC = vBNTGTT_old.NGAYKETTHUC;
                    vBNTGTT_new.GHICHU = vBNTGTT_old.GHICHU;
                    vBNTGTT_new.ISHOSO = vBNTGTT_old.ISHOSO;
                    vBNTGTT_new.ISSOTHAM = vBNTGTT_old.ISSOTHAM;
                    vBNTGTT_new.ISPHUCTHAM = vBNTGTT_old.ISPHUCTHAM;
                    vBNTGTT_new.ISTREVITHANHNIEN = vBNTGTT_old.ISTREVITHANHNIEN;
                    vBNTGTT_new.LOAITREVITHANHNIEN = vBNTGTT_old.LOAITREVITHANHNIEN;
                    vBNTGTT_new.LOAIDT = vBNTGTT_old.LOAIDT;
                    vBNTGTT_new.NDD_HOTEN = vBNTGTT_old.NDD_HOTEN;
                    vBNTGTT_new.NDD_CHUCVU = vBNTGTT_old.NDD_CHUCVU;
                    vBNTGTT_new.NDD_CMND = vBNTGTT_old.NDD_CMND;
                    vBNTGTT_new.NDD_MOBILE = vBNTGTT_old.NDD_MOBILE;
                    vBNTGTT_new.NDD_EMAIL = vBNTGTT_old.NDD_EMAIL;
                    vBNTGTT_new.FILEID = vBNTGTT_old.FILEID;
                    vBNTGTT_new.NGAYSUA = DateTime.Now;
                    vBNTGTT_new.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vBNTGTT_new.ID_NGUOITGTT_QLTACC = vBNTGTT_old.ID_NGUOITGTT_QLTACC;
                    vBNTGTT_new.TK_ISTHANTHICH = vBNTGTT_old.TK_ISTHANTHICH;
                    vBNTGTT_new.TK_ISQUENBIET = vBNTGTT_old.TK_ISQUENBIET;
                    vBNTGTT_new.TK_HAUQUA_BIHAI = vBNTGTT_old.TK_HAUQUA_BIHAI;
                    vBNTGTT_new.TK_TILE_ROILOANTAMTHAN = vBNTGTT_old.TK_TILE_ROILOANTAMTHAN;
                    // insert toa_gq_id
                    if (vBNTGTT_new.TOA_GIAIQUYET_ID == null && vBNTGTT_old.TOA_GIAIQUYET_ID != null)
                    {
                        vBNTGTT_new.TOA_GIAIQUYET_ID = vBNTGTT_old.TOA_GIAIQUYET_ID;
                    }
                    else
                    {
                        vBNTGTT_new.TOA_GIAIQUYET_ID = LoginDonViID;
                    }
                    dt.AHS_NGUOITHAMGIATOTUNG.Add(vBNTGTT_new);
                    dt.SaveChanges();

                    mapNTGTOTUNGOLD_NEW[vBNTGTT_old.ID] = vBNTGTT_new.ID;

                    var vBNTGTT_newID = vBNTGTT_new.ID;
                    List<AHS_NGUOITHAMGIATOTUNG_TUCACH> aHS_NGUOITHAMGIATOTUNG_TUCACH_OLDes = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == vBNTGTT_old.ID).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                    foreach (AHS_NGUOITHAMGIATOTUNG_TUCACH tucachOld in aHS_NGUOITHAMGIATOTUNG_TUCACH_OLDes)
                    {
                        var newNGUOI_TUCACH = new AHS_NGUOITHAMGIATOTUNG_TUCACH
                        {
                            NGUOIID = vBNTGTT_newID,
                            TUCACHID = tucachOld.TUCACHID
                        };
                        dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(newNGUOI_TUCACH);
                    }
                    dt.SaveChanges();
                }

                List<DON_KHAC> dON_KHAC_OLDs = dt.DON_KHAC.Where(x => x.DONID == vDonID && x.LOAIANID == 1 && x.LOAIDON == 8).ToList<DON_KHAC>();
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
                    if (dON_KHAC_OLD.ISDUONGSU != null && dON_KHAC_OLD.ISDUONGSU == 1 && mapDUONGSUIDOLD_NEW.ContainsKey(dON_KHAC_OLD.DUONGSUID))
                    {
                        dON_KHAC_NEW.DUONGSUID = mapDUONGSUIDOLD_NEW[dON_KHAC_OLD.DUONGSUID]; // Map id đương sự cũ và mới
                    }
                    else if (dON_KHAC_OLD.ISDUONGSU != null && dON_KHAC_OLD.ISDUONGSU == 0 && mapNTGTOTUNGOLD_NEW.ContainsKey(dON_KHAC_OLD.DUONGSUID))
                    {
                        dON_KHAC_NEW.DUONGSUID = mapNTGTOTUNGOLD_NEW[dON_KHAC_OLD.DUONGSUID];
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

                //them ma giai doan cap Phuc tham 
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE_XXLAI_SOTHAM("1", oDON_new.ID, 2, (decimal)LoginDonViID, 0, 0, 0, 0);
                //ket thuc OK
            }

        }

        protected void ck_GQTDC_QDK_CheckedChanged(object sender, EventArgs e)
        {
            if (Session["CAP_XET_XU"] + "" == "CAPTINH" && ck_GQTDC_QDK.Checked)
            {
                dropCapxx.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
            }
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ck_ANKETTHUC_CheckedChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
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

        //Link đến màn danh sách Thống kê quá hạn
        protected void lbtDanhSachQuaHan_Click(object sender, EventArgs e)
        {
            string link = "/QLAN/AHS/Hoso/Popup/pTKQuaHan.aspx";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv()");
        }
    }
}