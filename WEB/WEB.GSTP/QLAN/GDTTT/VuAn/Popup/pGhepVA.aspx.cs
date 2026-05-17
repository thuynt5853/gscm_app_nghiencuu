using BL.GSTP;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pGhepVA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal CurrUserID = 0;
        public Decimal DonID = 0;
        public String URL = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            DonID = String.IsNullOrEmpty(Request["dID"] + "") ? 0 : Convert.ToDecimal(Request["dID"] + "");

            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadThongTinDon();
                    LoadDropToaAn();
                    //Load_Data();
                }
            }
        }
        void LoadThongTinDon()
        {
            if (DonID > 0)
            {
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
                if (oT != null)
                {
                    int loaian = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : Convert.ToInt16(oT.BAQD_LOAIAN);
                    if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                        URL = "/QLAN/GDTTT/Giaiquyet/Popup/pVuAnHS.aspx?vid=";
                    else URL = "/QLAN/GDTTT/GiaiQuyet/Popup/pVuAn.aspx?vid=";
                    lttDon_SoCV.Text = oT.CD_SOCV;
                    lttDon_NgayCV.Text = (String.IsNullOrEmpty(oT.CD_NGAYCV + "") || (oT.CD_NGAYCV == DateTime.MinValue)) ? "" : ((DateTime)oT.CD_NGAYCV).ToString("dd/MM/yyyy", cul);
                    //------------------------
                    lttDon_SoThuLy.Text = oT.TL_SO;
                    lttDon_NgayThuLy.Text = (String.IsNullOrEmpty(oT.TL_NGAY + "") || (oT.TL_NGAY == DateTime.MinValue)) ? "" : ((DateTime)oT.TL_NGAY).ToString("dd/MM/yyyy", cul);

                    //------------------------
                    string toaxx = oT.BAQD_TENTOA;
                    decimal toaan_id = 0;
                    if (oT.BAQD_CAPXETXU == 2)
                    {
                        lttDon_SoBA.Text = oT.BAQD_SO_ST;
                        lttDon_NgayBA.Text = (String.IsNullOrEmpty(oT.BAQD_NGAYBA_ST + "") || (oT.BAQD_NGAYBA_ST == DateTime.MinValue)) ? "" : ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy", cul);
                        toaxx = oT.BAQD_TENTOA_ST;
                        toaan_id = Convert.ToDecimal(oT.BAQD_TOAANID_ST);
                    }
                    else if (oT.BAQD_CAPXETXU == 3)
                    {
                        lttDon_SoBA.Text = oT.BAQD_SO_PT;
                        lttDon_NgayBA.Text = (String.IsNullOrEmpty(oT.BAQD_NGAYBA_PT + "") || (oT.BAQD_NGAYBA_PT == DateTime.MinValue)) ? "" : ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy", cul);
                        toaxx = oT.BAQD_TENTOA_PT;
                        toaan_id = Convert.ToDecimal(oT.BAQD_TOAANID_PT);
                    }
                    else
                    {
                        lttDon_SoBA.Text = oT.BAQD_SO;
                        lttDon_NgayBA.Text = (String.IsNullOrEmpty(oT.BAQD_NGAYBA + "") || (oT.BAQD_NGAYBA == DateTime.MinValue)) ? "" : ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy", cul);
                        toaxx = oT.BAQD_TENTOA;
                        toaan_id = Convert.ToDecimal(oT.BAQD_TOAANID);
                    }

                    ////---------tu dong dien vao form search vu an-----------
                    //txtNgayBAQD.Text = lttDon_NgayBA.Text;
                    //txtSoQDBA.Text = lttDon_SoBA.Text;
                    //------------------------
                    if (string.IsNullOrEmpty(toaxx) && toaan_id > 0)
                        lttDon_ToaXX.Text = dt.DM_TOAAN.Where(x => x.ID == toaan_id).Single().MA_TEN;
                    else lttDon_ToaXX.Text = toaxx;
                    //----------------------
                    lttDon_NguoiGui.Text = oT.DONGKHIEUNAI;

                    //------------------------
                    if (!String.IsNullOrEmpty(oT.VUVIECID + "") && oT.VUVIECID > 0)
                    {
                        hddChoiceVuAn.Value = oT.VUVIECID.ToString();
                        Grid_SetSelectVuAn();
                        LoadThongTinVuAn(Convert.ToDecimal(oT.VUVIECID));
                    }
                    else
                    {
                        lttMsg.Text = "Chưa chọn vụ án nào!";
                        pnVuAn.Visible = false;
                    }
                }
            }
        }

        protected void cmdThemVA_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(URL))
            {
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
                if (oT != null)
                {
                    int loaian = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : Convert.ToInt16(oT.BAQD_LOAIAN);
                    if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                        URL = "/QLAN/GDTTT/Giaiquyet/Popup/pVuAnHS.aspx?vid=";
                    else URL = "/QLAN/GDTTT/GiaiQuyet/Popup/pVuAn.aspx?vid=";
                }
            }
            Response.Redirect(URL + DonID);
        }
        //----------------------------------
        protected void Page_PreRender(object sender, EventArgs e)
        {
            Grid_SetSelectVuAn();

            Decimal Choice_VuAnID = (string.IsNullOrEmpty(hddChoiceVuAn.Value)) ? 0 : Convert.ToDecimal(hddChoiceVuAn.Value);
            if (Choice_VuAnID > 0)
                LoadThongTinVuAn(Choice_VuAnID);
        }
        void Grid_SetSelectVuAn()
        {
            Decimal row_VuAnID = 0;
            //------------------------
            Decimal Choice_VuAnID = (string.IsNullOrEmpty(hddChoiceVuAn.Value)) ? 0 : Convert.ToDecimal(hddChoiceVuAn.Value);
            foreach (DataGridItem item in dgList.Items)
            {
                HiddenField hddVuAnID = (HiddenField)item.FindControl("hddVuAnID");
                row_VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                CheckBox chkChoice = (CheckBox)item.FindControl("chkChoice");
                if (Choice_VuAnID == row_VuAnID)
                {
                    chkChoice.Checked = true;
                }
                else chkChoice.Checked = false;
            }
        }
        void LoadThongTinVuAn(Decimal VuAnID)
        {
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (obj != null)
            {
                int loaian = String.IsNullOrEmpty(obj.LOAIAN + "") ? 0 : (int)obj.LOAIAN;
                if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                {
                    lttNguyenDon.Text = "Bị can đầu vụ";
                    lttBiDon.Text = "Bị can";
                }
                pnVuAn.Visible = true;
                lttMsg.Text = "";
                if (!String.IsNullOrEmpty(obj.TENVUAN + ""))
                    txtTenVuan.Text = obj.TENVUAN;
                else
                {
                    txtTenVuan.Text = obj.NGUYENDON + " - " + obj.BIDON;
                    if (obj.QHPL_DINHNGHIAID != null && obj.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == obj.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                //------------------------
                txtVuAn_SoThuLy.Text = obj.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                //----------------------------------
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);

                //-------------------------------------
                Decimal temp_id = 0;
                string temp_str = "", temp = "";
                #region BA/QD so tham, phuc tham
                try
                {
                    txtVuAn_SoBanAn.Text = obj.SOANPHUCTHAM + "";
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                }
                catch (Exception ex) { }

                DM_TOAAN objTA = null;
                temp_id = String.IsNullOrEmpty(obj.TOAPHUCTHAMID + "") ? 0 : (decimal)obj.TOAPHUCTHAMID;
                if (temp_id > 0)
                {
                    objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                    lttToaXuPT.Text = objTA.MA_TEN;
                    //------------------
                    temp = temp_str = "";
                    if (objTA.LOAITOA == "CAPCAO")
                    {
                        temp_id = (string.IsNullOrEmpty(obj.TOAANSOTHAM + "")) ? 0 : (decimal)obj.TOAANSOTHAM;
                        if (temp_id > 0)
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                            temp = "<tr>";
                            temp += "<td>Tòa xử sơ thẩm</td>";
                            temp += "<td colspan='3'>" + objTA.MA_TEN + "</td>";
                            temp += "</tr>";
                        }
                        //------------------------
                        temp_str = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                        string soansotham = String.IsNullOrEmpty(obj.SOANSOTHAM + "") ? "" : obj.SOANSOTHAM;
                        if ((soansotham != "") || (temp_str != ""))
                        {
                            temp += "<tr>";
                            temp += "<td>Số BA/QĐ sơ thẩm</td>";
                            temp += "<td>" + obj.SOANSOTHAM + "</td>";
                            temp += "<td>Ngày BA/QĐ sơ thẩm</td>";
                            temp += "<td>" + temp_str + "</td>";
                            temp += "</tr>";
                        }
                    }
                }

                #endregion
                lttOther.Text += temp;
            }
            else { lttMsg.Text = "Chưa chọn vụ án nào!"; pnVuAn.Visible = false; }
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
        //------------------------------------
        void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }

        private void Load_Data()
        {
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
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

            //THUONGNX 01/10/2019
            if (DonID > 0)
            {
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
                if (oT != null)
                {
                    int loaian = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : Convert.ToInt16(oT.BAQD_LOAIAN);
                    if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                    {
                        dgList.Columns[4].HeaderText = "Tội danh";
                        dgList.Columns[5].HeaderText = "Bị cáo đầu vụ ";
                        dgList.Columns[6].HeaderText = "Bị cáo khiếu nại";
                    }
                }
            }

            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();



        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = "", vBidon = "";
            decimal vLoaiAn = 0, vThamtravien = 0, vLanhdao = 0, vThamphan = 0;
            decimal vQHPLID = 0, vQHPLDNID = 0;
            string vCoquanchuyendon = "", vNguoiGui = "";

            decimal vTraloidon = 2, vLoaiCVID = 0;

            DateTime? vNgayThulyTu = (DateTime?)null;
            DateTime? vNgayThulyDen = (DateTime?)null;
            string vSoThuly = "";
            decimal vTrangthai = 0;
            decimal vKetquathuly = 3;
            decimal vKetquaxetxu = 0;

            int isTotrinh = 2, isYKienKLToTrinh = 2, isBuocTT = 0;
            int isMuonHoSo = 2, isHoanTHA = 2, LoaiAnDB = 0;

            DataTable tbl = null;
            if (vLoaiCVID == 0)
                tbl = oBL.VUAN_SEARCH(Session[ENUM_SESSION.SESSION_USERID] + "", "0","NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                   , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                   , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
                   , vTrangthai, vKetquathuly, vKetquaxetxu
                   , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB,null, isHoanTHA
                   , 0, 2, 0, 0,0,0,0,0,null
                   ,1,null,null
                   , pageindex, page_size);
            else
                tbl = oBL.GDTTTT_VUAN_SEARCH_ANQH("NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
              , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
              , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
              , vTrangthai, vKetquathuly, vKetquaxetxu
              , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, isHoanTHA
              , 0, 2, 0, 0
              , pageindex, page_size);
            return tbl;
        }

        Decimal trangthai_trinh_id = 0;
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                temp = "";

                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");

                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");
                CheckBox chkChoice = (CheckBox)e.Item.FindControl("chkChoice");
                chkChoice.Attributes.Add("onchange", "ChoiceVuAn(" + CurrVuAnID + ")");

                //----------------------------------
                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                if ((trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_THAMPHAN)
                    || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_PHOVT)
                    || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_VUTRUONG))
                {
                    #region Thông tin lien quan den To trinh
                    try
                    {
                        trangthai_trinh_id = Convert.ToDecimal(trangthai);
                        List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID
                                                          && x.TINHTRANGID == trangthai_trinh_id).OrderByDescending(y => y.NGAYTRINH).ToList();
                        if (lstTT != null && lstTT.Count > 0)
                        {
                            lttLanTT.Text += " lần " + lstTT.Count.ToString();

                            GDTTT_TOTRINH objTT = lstTT[0];
                            if (!string.IsNullOrEmpty(objTT.NGAYTRINH + "") || (DateTime)objTT.NGAYTRINH != DateTime.MinValue)
                                lttDetaiTinhTrang.Text = "<br/><span style='margin-right:10px;'>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul) + "</span>";

                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(lttDetaiTinhTrang.Text)) ? "" : "<br/>";
                            lttDetaiTinhTrang.Text += objTT.YKIEN + "";
                        }
                    }
                    catch (Exception ex) { }
                    #endregion
                }
                else
                {
                    if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV)
                    {
                        //hien ngay phan cong + qua trinh_ghi chu (GDTTT_VuAn)                       
                        lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (rv["NGAYPHANCONGTTV"].ToString() + "<br/>"))
                                                    + rv["QUATRINH_GHICHU"] + "";
                    }
                    else if (GiaiDoanTrinh == 3 && trangthai != 15)
                    {
                        int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 4 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                        if (loai_giaiquyet_don <= 2)
                        {
                            if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                lttDetaiTinhTrang.Text = rv["AHS_ThongTinGQD"] + "";
                            }
                            else
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                lttDetaiTinhTrang.Text = temp;
                            }
                        }
                        else
                            lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                    }

                    //else if ((trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRALOIDON)
                    //        || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.KHANGNGHI)
                    //        || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.XEPDON))
                    //{
                    //    //--------tra loi don / khang nghi/ xep don --> lấy số + Ngày (GDTTT_VuAn)
                    //    temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style='margin-right:10px;'>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                    //    temp += (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<span style=''>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b></span>");
                    //    lttDetaiTinhTrang.Text = temp;
                    //}
                }


                //-------------------------------
                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                int IsHoanTHA = Convert.ToInt16(rv["GQD_IsHoanTHA"] + "");
                if (IsHoanTHA > 0)
                {
                    lttKQGQ.Text = "<span class='line_space'>";
                    lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                    lttKQGQ.Text += "<span style='margin-right:10px;'>Số: <b>" + rv["GQD_HoanTHA_So"].ToString() + "</b></span>";
                    lttKQGQ.Text += "<span style=''>Ngày: <b>" + rv["GQD_HoanTHA_Ngay"].ToString() + "</b></span><br/>";
                    lttKQGQ.Text += "";
                    lttKQGQ.Text += "</span>";
                }

                //---------------------------
                Literal lttOther = (Literal)e.Item.FindControl("lttOther");
                int soluong = String.IsNullOrEmpty(rv["IsHoSo"] + "") ? 0 : Convert.ToInt32(rv["IsHoSo"] + "");
                string NgayTTVNhanHS = rv["NgayTTVNhanHS"] + "";
                // lttOther.Text = "<div class='line_space'><b>" + ((soluong > 0) ? "Đã có hồ sơ" : "Chưa có hồ sơ") + "</b></div>";
                lttOther.Text = "<div class='line_space'><b>" + ((soluong > 0) ? "Đã có hồ sơ" + (string.IsNullOrEmpty(NgayTTVNhanHS) ? "" : " (" + NgayTTVNhanHS + ")") : "") + "</b></div>";
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("Thongtinvuan.aspx?ID=" + e.CommandArgument.ToString());
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


        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        String temp = "";

        protected void cmdSave_Click(object sender, EventArgs e)
        {
            Decimal VuAnID = Convert.ToDecimal(hddChoiceVuAn.Value);
            Decimal DonID = String.IsNullOrEmpty(Request["dID"] + "") ? 0 : Convert.ToDecimal(Request["dID"] + "");
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal PhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            if (VuAnID > 0)
            {
                GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
                if (obj != null)
                {
                    obj.VUVIECID = VuAnID;
                    dt.SaveChanges();
                    //-------------------------
                    if (obj.ISTHULY == 1 && obj.BAQD_LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                    {
                        //--them nguoi khieu nai--------
                        ThemNguoiKhieuNai(VuAnID, obj.NGUOIGUI_HOTEN);
                    }
                    //-------------------------
                    hddReloadParent.Value = "1";
                    lttMsg.Text = "<div class='msg_error' style='font-size:13pt;'>" + "Ghép vụ án thành công!" + "</div>";
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ghép vụ án thành công!");
                    //----------------------
                    DateTime vNgayNhan = DateTime.Now;
                    if ((obj.CD_TRANGTHAI == 1 || obj.CD_TRANGTHAI == 2) && obj.CD_LOAI == 0)
                    {
                        #region Update trang thai don
                        if (obj.CD_TRANGTHAI == 1 && obj.CD_LOAI == 0)
                        {
                            obj.CD_TRANGTHAI = 2;
                            obj.CD_NGAYXULY = vNgayNhan;
                            obj.VUVIECID = VuAnID;
                            dt.SaveChanges();
                        }
                        #endregion

                        #region update don chuyen
                        //Update danh sách lịch sử chuyển đơn;
                        List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID
                                                                                    && x.DONVINHANID == ToaAnID
                                                                                    && x.PHONGBANNHANID == PhongbanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                        if (lstC.Count > 0)
                        {
                            GDTTT_DON_CHUYEN oC = lstC[0];
                            if (oC.TRANGTHAI == 1)
                            {
                                oC.NGAYNHAN = vNgayNhan;
                                oC.TRANGTHAI = 2;
                                oC.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                dt.SaveChanges();
                            }
                            ////Update danh sách các đơn chuyển cùng
                            string strArrDon = oC.ARRDONTRUNG;
                            string[] strarr = strArrDon.Split(',');
                            if (strarr.Length > 1)
                            {
                                GDTTT_DON oDT = null;
                                Decimal currr_id = 0;
                                foreach (String item in strarr)
                                {
                                    if (item.Length > 0)
                                    {
                                        currr_id = Convert.ToDecimal(item);
                                        if (currr_id != DonID)
                                        {
                                            oDT = dt.GDTTT_DON.Where(x => x.ID == currr_id).Single();
                                            oDT.CD_TRANGTHAI = 2;
                                            oDT.VUVIECID = VuAnID;
                                        }
                                    }
                                }
                                dt.SaveChanges();
                            }
                        }
                        #endregion
                    }
                }

                //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
                GDTTT_DON_BL objBL = new GDTTT_DON_BL();
                objBL.Update_Don_TH(VuAnID);
            }
        }
        decimal ThemNguoiKhieuNai(Decimal CurrVuAnID, String TenDS)
        {
            String TenNguoiKhieuNai = TenDS.Trim().ToLower();
            Boolean IsUpdate = false;
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                         && x.HS_ISKHIEUNAI == 1
                                                                         && x.TENDUONGSU.Trim().ToLower() == TenNguoiKhieuNai).ToList();
            if (lst != null && lst.Count > 0)
            {
                obj = lst[0]; IsUpdate = true;
            }
            else
            {
                obj = new GDTTT_VUAN_DUONGSU();
            }
            obj.VUANID = CurrVuAnID;

            obj.LOAI = 0;
            obj.GIOITINH = 2;

            obj.BICAOID = 0;
            obj.HS_TUCACHTOTUNG = "";
            //----------------------
            obj.HS_ISKHIEUNAI = 1;
            obj.HS_BICANDAUVU = 0;
            obj.HS_ISBICAO = 0;
            //----------------------
            obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.KHAC;
            obj.TENDUONGSU = Cls_Comon.FormatTenRieng(TenDS.Trim());
            obj.HS_MUCAN = "";

            obj.DIACHI = "";
            //----------------------
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

                dt.GDTTT_VUAN_DUONGSU.Add(obj);
                dt.SaveChanges();
            }
            //-------------------------
            return obj.ID;
        }
    }
}