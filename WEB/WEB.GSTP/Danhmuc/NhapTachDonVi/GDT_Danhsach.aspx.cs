using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

namespace WEB.GSTP.Danhmuc.NhapTachDonVi
{
    public partial class GDT_Danhsach : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "..";
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        String temp = "";
        Decimal PhongBanID = 0, CurrDonViID = 0, CANBO_ID = 0;
        String UserName = "";
        decimal trangthai_trinh_id = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            CANBO_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            try
            {
                if (!IsPostBack)
                {
                  
                    hddPageIndex.Value = "1";
                    hddPageIndexN.Value = "1";
                    string strPath = Request.FilePath.ToString().ToLower();

                    //MenuPermission oPer = Cls_Comon.GetMenuPer(strPath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdLammoi, oPer.TAOMOI);
                    //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

                    
                    LoadDropToaAn();
                    //Loại án
                    LoadDropLoaiAn();
                    //Loại án Ttheo đơn vị nhận
                    LoadDropLoaiAn_Nhan();
                    //Ly do chuyen du lieu
                    LoadLyDo();

                }
            }
            catch (Exception ex) { }
        }
        private void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
           
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GET_GDTT(1, 0,null);
            ddlToaAn.DataSource = dtTA;
            ddlToaAn.DataTextField = "MA_TEN";
            ddlToaAn.DataValueField = "ID";
            ddlToaAn.DataBind();
            //ddlToaAn.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            LoadPhongChuyen(ToaAnID);
            LoadPhongNhan(ToaAnID);

        }
        
        protected void ddlToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal( ddlToaAn.SelectedValue);
            LoadPhongChuyen(ToaAnID);
            LoadPhongNhan(ToaAnID);
        }

        private void LoadPhongNhan(decimal TOAANID)
        {
            List<DM_PHONGBAN> dtPhong = dt.DM_PHONGBAN.Where(x => x.TOAANID == TOAANID && x.HIEULUC == 1 && x.ISGIAIQUYETDON == 1).ToList();
            ddlPhongChuyen.DataSource = dtPhong;
            ddlPhongChuyen.DataTextField = "TENPHONGBAN";
            ddlPhongChuyen.DataValueField = "ID";
            ddlPhongChuyen.DataBind();
            ddlPhongChuyen.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }

        private void LoadPhongChuyen(decimal TOAANID)
        {
            decimal vHieuluc = (chkActive.Checked) ? 1 : 0;
            List<DM_PHONGBAN> dtPhong = dt.DM_PHONGBAN.Where(x => x.TOAANID == TOAANID && x.HIEULUC == vHieuluc && x.ISGIAIQUYETDON == 1).ToList();
            ddlPhongNhan.DataSource = dtPhong;
            ddlPhongNhan.DataTextField = "TENPHONGBAN";
            ddlPhongNhan.DataValueField = "ID";
            ddlPhongNhan.DataBind();
            ddlPhongNhan.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }

        private void LoadLyDo()
        {
            DM_DATAITEM_BL soBL = new DM_DATAITEM_BL();
            DataTable tblLydo = soBL.DM_DATAITEM_GETBYGROUPNAME("NHAPTACH_DONVI");
            if (tblLydo.Rows.Count > 0)
            {
                ddlLyDo.DataSource = tblLydo;
                ddlLyDo.DataTextField = "TEN";
                ddlLyDo.DataValueField = "MA";
                ddlLyDo.DataBind();
                ddlLyDo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                
            }

        }


        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }
        protected void chkChonAllHS_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in gridHS.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        protected void lbtActive_Click(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            LoadPhongChuyen(ToaAnID);
           
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);
            foreach (DataGridItem Item in dgList.Items)
            {


            }
        }

        protected void ddlPhongChuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropLoaiAn();
            LoadDS_VuAN();
        }
        void LoadDropLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            string strPBID = ddlPhongChuyen.SelectedValue + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            if (PBID > 0)
            {
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                if (ddlLoaiAn.Items.Count > 1 && obj.ISHINHSU != 1)
                    ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                

            }else
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

        }

        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDS_VuAN();
        }


        private DataTable getDS(int page_size, int pageindex)
        {

            decimal vToaAnID = Convert.ToDecimal(ddlToaAn.SelectedValue);
            decimal vPhongBanID = Convert.ToDecimal(ddlPhongChuyen.SelectedValue);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            string vSoBA = txtSoBA.Text;
            string vNgayBA = txtNgayBA.Text;
            //--------------
            DataTable oDT = oBL.GDTTT_DANHSACH_VUAN_SEARCH(vToaAnID,
                vPhongBanID, vLoaiAn, vKetquathuly, vSoBA, vNgayBA
                , pageindex, page_size);
            return oDT;
        }



        private void LoadDS_VuAN()
        {
            
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
                lstSobanghiT.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
              
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = "Không có kết quả !";
                
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                gridHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                gridHS.DataSource = oDT;
                gridHS.DataBind();
                gridHS.Visible = true;
                dgList.Visible = false;
               
            }
            else
            {
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; gridHS.Visible = false;
               
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");

                trangthai_trinh_id = 0;
                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");

                decimal KQ_GQD_ID = String.IsNullOrEmpty(rv["KQ_GQD_ID"] + "") ? 0 : Convert.ToInt32(rv["KQ_GQD_ID"] + "");
                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                if (trangthai != ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV && GiaiDoanTrinh == 2)
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
                                lttDetaiTinhTrang.Text = "<br/>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul);
                            if (!string.IsNullOrEmpty(objTT.NGAYTRA + "") || (DateTime)objTT.NGAYTRA != DateTime.MinValue)
                                lttDetaiTinhTrang.Text += "<br/><span style='margin-right:10px;'>Ngày trả: " + Convert.ToDateTime(objTT.NGAYTRA).ToString("dd/MM/yyyy", cul) + "</span>";

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
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                    }
                    else if (GiaiDoanTrinh == 3 && trangthai != 15)
                    {
                        int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                        if (loai_giaiquyet_don <= 2)
                        {
                            String temp = "";
                            int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                            if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                if (loai_giaiquyet_don == 0)
                                    lttDetaiTinhTrang.Text = rv["AHS_THONGTINGQD"] + "";
                                else
                                {
                                    temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                    temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                    temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                lttDetaiTinhTrang.Text = temp;
                            }
                        }
                        else if (loai_giaiquyet_don == 4)
                            lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                        else
                            lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                    }
                    else if (trangthai == 15)
                    {
                        lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["SOTHULYXXGDT"].ToString() + "</b></span>");
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : ("Ngày: <b>" + rv["NGAYTHULYXXGDT"].ToString() + "</b>");

                        if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + "")
                                    || !String.IsNullOrEmpty(rv["KetQuaXXGDT"] + "")
                                    || !String.IsNullOrEmpty(rv["XXGDTTT_NGAYQD"] + ""))
                        {
                            lttKQGQ.Text += "<span class='line_space'>";
                            lttKQGQ.Text += "<span style='float:left;width:100%;display:block;'>Kết quả XX</span>";
                            //------------------------------------  
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                lttKQGQ.Text += "<span style='padding-right:10px;'><b>" + rv["XXGDTTT_SOQD"].ToString() + "</b></span>";
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                lttKQGQ.Text += "<span><b>" + rv["XXGDTTT_NGAYQD"].ToString() + "</b></span>";

                            if (lttKQGQ.Text != "")
                            {
                                lttKQGQ.Text += "<br/>";
                                if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                    lttKQGQ.Text += "<span style='padding-right:10px;'>Ngày xử: <b>" + rv["NGAYXUGIAMDOCTHAM"].ToString() + "</b></span>";
                            }
                            //--------------------------                    
                            if (!String.IsNullOrEmpty(rv["KetQuaXXGDT"] + ""))
                            {
                                lttKQGQ.Text += "<br/>";
                                lttKQGQ.Text += "<span style=''>KQ: <b>" + rv["KetQuaXXGDT"].ToString() + "</b></span>";
                            }
                            // Ap dung an le khong
                            if (!String.IsNullOrEmpty(rv["inforAnLe"] + ""))
                            {
                                lttKQGQ.Text += "<span style=''><b>" + rv["inforAnLe"].ToString() + "</b></span>";
                            }
                            
                            lttKQGQ.Text += "</span>";
                        }
                        

                    }
                }
                
            }
        }

        void LoadDropLoaiAn_Nhan()
        {
            ddlLoaiAn_Nhan.Items.Clear();
            string strPBID = ddlPhongNhan.SelectedValue + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            if (PBID > 0)
            {
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                if (obj.ISDANSU == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn_Nhan.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                if (ddlLoaiAn_Nhan.Items.Count > 1 && obj.ISHINHSU != 1)
                    ddlLoaiAn_Nhan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else
                ddlLoaiAn_Nhan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

        }

        protected void ddlLoaiAn_Nhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDS_VuAN_Nhan();
        }
        protected void ddlPhongNhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropLoaiAn_Nhan();
            LoadDS_VuAN_Nhan();
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDS_VuAN();
            LoadDS_VuAN_Nhan();
        }
        private DataTable getDS_Nhan(int page_size, int pageindex)
        {

            decimal vToaAnID = Convert.ToDecimal(ddlToaAn.SelectedValue);
            decimal vPhongBanID = Convert.ToDecimal(ddlPhongNhan.SelectedValue);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();         
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn_Nhan.SelectedValue);
          
            //--------------
            DataTable oDT = oBL.DANHSACH_VUAN_NHAN(vToaAnID, vPhongBanID, vLoaiAn
                , pageindex, page_size);
            return oDT;
        }

        private void LoadDS_VuAN_Nhan()
        {

            lbTFirst.Visible = ddlPageCountN.Visible = lbBFirst.Visible = ddlPageCount2N.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCountN.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndexN.Value);
            DataTable oDT = getDS_Nhan(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPageN.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCountN.SelectedValue)).ToString();
                lstSobanghiNhan.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPageN.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPageN, hddPageIndexN, lbTFirstN, lbBFirstN, lbTLastN, lbBLastN, lbTNextN, lbBNextN, lbTBackN, lbBBackN, lbTStep1N, lbBStep1N, lbTStep2N,
                             lbBStep2N, lbTStep3N, lbBStep3N, lbTStep4N, lbBStep4N, lbTStep5N, lbBStep5N, lbTStep6N, lbBStep6N);
                #endregion

            }
            else
            {
                hddTotalPageN.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPageN, hddPageIndexN, lbTFirstN, lbBFirstN, lbTLastN, lbBLastN, lbTNextN, lbBNextN, lbTBackN, lbBBackN, lbTStep1N, lbBStep1N, lbTStep2N,
                             lbBStep2N, lbTStep3N, lbBStep3N, lbTStep4N, lbBStep4N, lbTStep5N, lbBStep5N, lbTStep6N, lbBStep6N);
                lstSobanghiNhan.Text = "Không có kết quả !";

            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                dgList_Nhan_HS.PageSize = Convert.ToInt32(ddlPageCountN.SelectedValue);
                dgList_Nhan_HS.DataSource = oDT;
                dgList_Nhan_HS.DataBind();
                dgList_Nhan_HS.Visible = true;
                dgList_Nhan.Visible = false;

            }
            else
            {
                dgList_Nhan.PageSize = Convert.ToInt32(ddlPageCountN.SelectedValue);
                dgList_Nhan.DataSource = oDT;
                dgList_Nhan.DataBind();
                dgList_Nhan.Visible = true; dgList_Nhan_HS.Visible = false;

            }
        }

        protected void dgList_Nhan_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");

                trangthai_trinh_id = 0;
                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");

                decimal KQ_GQD_ID = String.IsNullOrEmpty(rv["KQ_GQD_ID"] + "") ? 0 : Convert.ToInt32(rv["KQ_GQD_ID"] + "");
                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                if (trangthai != ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV && GiaiDoanTrinh == 2)
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
                                lttDetaiTinhTrang.Text = "<br/>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul);
                            if (!string.IsNullOrEmpty(objTT.NGAYTRA + "") || (DateTime)objTT.NGAYTRA != DateTime.MinValue)
                                lttDetaiTinhTrang.Text += "<br/><span style='margin-right:10px;'>Ngày trả: " + Convert.ToDateTime(objTT.NGAYTRA).ToString("dd/MM/yyyy", cul) + "</span>";

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
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                    }
                    else if (GiaiDoanTrinh == 3 && trangthai != 15)
                    {
                        int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                        if (loai_giaiquyet_don <= 2)
                        {
                            String temp = "";
                            int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                            if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                if (loai_giaiquyet_don == 0)
                                    lttDetaiTinhTrang.Text = rv["AHS_THONGTINGQD"] + "";
                                else
                                {
                                    temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                    temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                    temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();
                                
                                lttDetaiTinhTrang.Text = temp;
                            }
                        }
                        else if (loai_giaiquyet_don == 4)
                            lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                        else
                            lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                    }
                    else if (trangthai == 15)
                    {
                        lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["SOTHULYXXGDT"].ToString() + "</b></span>");
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : ("Ngày: <b>" + rv["NGAYTHULYXXGDT"].ToString() + "</b>");

                        if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + "")
                                   || !String.IsNullOrEmpty(rv["KetQuaXXGDT"] + "")
                                   || !String.IsNullOrEmpty(rv["XXGDTTT_NGAYQD"] + ""))
                        {
                            lttKQGQ.Text += "<span class='line_space'>";
                            lttKQGQ.Text += "<span style='float:left;width:100%;display:block;'>Kết quả XX</span>";
                            //------------------------------------  
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                lttKQGQ.Text += "<span style='padding-right:10px;'><b>" + rv["XXGDTTT_SOQD"].ToString() + "</b></span>";
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                lttKQGQ.Text += "<span><b>" + rv["XXGDTTT_NGAYQD"].ToString() + "</b></span>";

                            if (lttKQGQ.Text != "")
                            {
                                lttKQGQ.Text += "<br/>";
                                if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                    lttKQGQ.Text += "<span style='padding-right:10px;'>Ngày xử: <b>" + rv["NGAYXUGIAMDOCTHAM"].ToString() + "</b></span>";
                            }
                            //--------------------------                    
                            if (!String.IsNullOrEmpty(rv["KetQuaXXGDT"] + ""))
                            {
                                lttKQGQ.Text += "<br/>";
                                lttKQGQ.Text += "<span style=''>KQ: <b>" + rv["KetQuaXXGDT"].ToString() + "</b></span>";
                            }
                            // Ap dung an le khong
                            if (!String.IsNullOrEmpty(rv["inforAnLe"] + ""))
                            {
                                lttKQGQ.Text += "<span style=''><b>" + rv["inforAnLe"].ToString() + "</b></span>";
                            }

                            lttKQGQ.Text += "</span>";
                        }
                    }
                }

               
            }
        }
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadDS_VuAN();
            dgList_Nhan.CurrentPageIndex = 0;
            hddPageIndexN.Value = "1";
            LoadDS_VuAN_Nhan();

        }
        protected void btnChuyenDL_Click(object sender, EventArgs e)
        {
            //Kiểm tra xem loai an chuyển sang đúng đơn vị giải quyết không
            try {
                ddlLoaiAn_Nhan.SelectedValue = ddlLoaiAn.SelectedValue;

                //Lấy các đơn id sẽ chuyển 
                string vVuAn_chon = null;
                if (ddlLoaiAn.SelectedValue == "01")
                {
                    foreach (DataGridItem Item in gridHS.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            string strID = Item.Cells[0].Text;
                            if (vVuAn_chon == null)
                                vVuAn_chon = strID;
                            else
                                vVuAn_chon = vVuAn_chon + ',' + strID;
                        }

                    }
                }
                else
                {
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            string strID = Item.Cells[0].Text;
                            if (vVuAn_chon == null)
                                vVuAn_chon = strID;
                            else
                                vVuAn_chon = vVuAn_chon + ',' + strID;
                        }

                    }

                }
                

                if (vVuAn_chon == null)
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn chưa chọn dữ liệu để chuyển!')", true);
                    return;
                }
                else
                {


                    decimal vDonvichuyen = Convert.ToDecimal(ddlPhongChuyen.SelectedValue);
                    decimal vDonvinhan = Convert.ToDecimal(ddlPhongNhan.SelectedValue);
                    string vLydo = ddlLyDo.SelectedValue;
                    string vGhichu = txtGhichu.Text;
                    decimal vKetquaGQ = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);

                    ///insert vào bảng NHAP_TACH_DONVI va chuyển dữ liệu
                    GDTTT_VUAN_BL objVuAn = new GDTTT_VUAN_BL();
                    objVuAn.NHAP_TACH_DONVI_INSERT(vKetquaGQ, CurrDonViID, vDonvinhan, vDonvichuyen, vLydo, vGhichu, vVuAn_chon, CANBO_ID, UserName);
                    LoadDS_VuAN();
                    LoadDS_VuAN_Nhan();
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chuyển dữ liệu thành công!')", true);
                }
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đơn vị mới không được phân giải quyết loại án này!')", true);
                return;
            };

        }
              
      
       
        #region "Phân trang chuyen"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDS_VuAN();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadDS_VuAN();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDS_VuAN();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDS_VuAN();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDS_VuAN();
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadDS_VuAN();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadDS_VuAN();
        }
        #endregion

        #region "Phân trang nhan"
        protected void lbTBackN_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndexN.Value = (Convert.ToInt32(hddPageIndexN.Value) - 1).ToString();
            LoadDS_VuAN_Nhan();
        }

        protected void lbTFirstN_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndexN.Value = "1";
            LoadDS_VuAN_Nhan();
        }

        protected void lbTLastN_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndexN.Value = Convert.ToInt32(hddTotalPageN.Value).ToString();
            LoadDS_VuAN_Nhan();
        }

        protected void lbTNextN_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndexN.Value = (Convert.ToInt32(hddPageIndexN.Value) + 1).ToString();
            LoadDS_VuAN_Nhan();
        }

        protected void lbTStepN_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndexN.Value = lbCurrent.Text;
            LoadDS_VuAN_Nhan();
        }
        protected void ddlPageCountN_SelectedIndexChanged(object sender, EventArgs e)
        {
            //  dgList.CurrentPageIndex = 0;
            hddPageIndexN.Value = "1";
            LoadDS_VuAN_Nhan();
        }
        protected void ddlPageCount2N_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCountN.SelectedValue = ddlPageCount2N.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadDS_VuAN_Nhan();
        }
        #endregion
    }
}