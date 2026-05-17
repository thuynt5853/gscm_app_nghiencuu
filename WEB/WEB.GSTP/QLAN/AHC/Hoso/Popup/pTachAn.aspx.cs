using BL.GSTP;
using BL.GSTP.DONGHEP;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHC.Hoso.Popup
{
    public partial class pTachAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonGocID = 0;
        static decimal DonDaiDienID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            DonGocID = Convert.ToDecimal(Request.QueryString["DonID"].ToString());
            if (!IsPostBack)
            {
                Load_VuAnGoc();
                Load_Grid_DonChiTiet();
                Load_Grid_DonKhac();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            }
        }

        private void Load_VuAnGoc()
        {
            AHC_DON_BL oBL = new AHC_DON_BL(); //KHAI- AHC

            AHC_DON donGoc = dt.AHC_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

            DataTable oDT = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donGoc.MAVUVIEC, "", "", donGoc.TOAANID.ToString(),
                                            "", "", "", "", "", "", "", "", "", "",
                                            "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 0, 1, 1);
            dgVuAnGoc.PageSize = 1;
            dgVuAnGoc.DataSource = oDT;
            dgVuAnGoc.DataBind();
        }

        private void Load_Grid_DonChiTiet()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int page_size = 10,
                pageindex = Convert.ToInt32(hddPageIndex.Value);
            DONGHEP_BL oBL = new DONGHEP_BL();
            DataTable oDT = oBL.GetDonGhep(vDonViID, DonGocID, 6); //KHAI- AHC

            if (oDT != null && oDT.Rows.Count > 0)
            {
                var count_all = Convert.ToInt32(oDT.Rows.Count);
                if (dgList.CurrentPageIndex > (Convert.ToInt32(hddTotalPage.Value) - 1))
                {
                    dgList.CurrentPageIndex = 0;
                }

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2, lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2, lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            }

            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        private void Load_Grid_DonKhac()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int page_size = 10,
                pageindex = Convert.ToInt32(hddPageIndex.Value);
            DONGHEP_BL oBL = new DONGHEP_BL();
            DataTable oDT = oBL.GetDonGhepDonKC(vDonViID, DonGocID, 6); //KHAI- AHC

            if (oDT != null && oDT.Rows.Count > 0)
            {
                var count_all = Convert.ToInt32(oDT.Rows.Count);
                if (dgListKhac.CurrentPageIndex > (Convert.ToInt32(hddTotalPage_Khac.Value) - 1))
                {
                    dgListKhac.CurrentPageIndex = 0;
                }
                #region "Xác định số lượng trang"
                hddTotalPage_Khac.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT_Khac.Text = lstSobanghiB_Khac.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage_Khac.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage_Khac, hddPageIndex_Khac, lbTFirst_Khac, lbBFirst_Khac, lbTLast_Khac, lbBLast_Khac, lbTNext_Khac, lbBNext_Khac, lbTBack_Khac, lbBBack_Khac, lbTStep1_Khac, lbBStep1_Khac, lbTStep2_Khac, lbBStep2_Khac, lbTStep3_Khac, lbBStep3_Khac, lbTStep4_Khac, lbBStep4_Khac, lbTStep5_Khac, lbBStep5_Khac, lbTStep6_Khac, lbBStep6_Khac);
                #endregion
            }
            else
            {
                hddTotalPage_Khac.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage_Khac, hddPageIndex_Khac, lbTFirst_Khac, lbBFirst_Khac, lbTLast_Khac, lbBLast_Khac, lbTNext_Khac, lbBNext_Khac, lbTBack_Khac, lbBBack_Khac, lbTStep1_Khac, lbBStep1_Khac, lbTStep2_Khac, lbBStep2_Khac, lbTStep3_Khac, lbBStep3_Khac, lbTStep4_Khac, lbBStep4_Khac, lbTStep5_Khac, lbBStep5_Khac, lbTStep6_Khac, lbBStep6_Khac);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            dgListKhac.DataSource = oDT;
            dgListKhac.DataBind();
        }

        #region "PHÂN TRANG DS ĐƠN CHI TIẾT"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Grid_DonChiTiet();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Grid_DonChiTiet();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Grid_DonChiTiet();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Grid_DonChiTiet();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Grid_DonChiTiet();
        }
        #endregion

        #region "PHÂN TRANG DS ĐƠN KHÁC"
        protected void lbTBack_Khac_Click(object sender, EventArgs e)
        {
            dgListKhac.CurrentPageIndex = Convert.ToInt32(hddPageIndex_Khac.Value) - 2;
            hddPageIndex_Khac.Value = (Convert.ToInt32(hddPageIndex_Khac.Value) - 1).ToString();
            Load_Grid_DonKhac();
        }

        protected void lbTFirst_Khac_Click(object sender, EventArgs e)
        {
            dgListKhac.CurrentPageIndex = 0;
            hddPageIndex_Khac.Value = "1";
            Load_Grid_DonKhac();
        }

        protected void lbTLast_Khac_Click(object sender, EventArgs e)
        {
            dgListKhac.CurrentPageIndex = Convert.ToInt32(hddTotalPage_Khac.Value) - 1;
            hddPageIndex_Khac.Value = Convert.ToInt32(hddTotalPage_Khac.Value).ToString();
            Load_Grid_DonKhac();
        }

        protected void lbTNext_Khac_Click(object sender, EventArgs e)
        {
            dgListKhac.CurrentPageIndex = Convert.ToInt32(hddPageIndex_Khac.Value);
            hddPageIndex_Khac.Value = (Convert.ToInt32(hddPageIndex_Khac.Value) + 1).ToString();
            Load_Grid_DonKhac();
        }

        protected void lbTStep_Khac_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgListKhac.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex_Khac.Value = lbCurrent.Text;
            Load_Grid_DonKhac();
        }
        #endregion

        protected void cmdTachAn_Click(object sender, EventArgs e)
        {
            decimal donID_DonTach = 0, count = 0, countDaiDien = 0;
            bool myCheck = false;

            DON_CHITIET objDCT = new DON_CHITIET();

            string strDuongSuDonTachID = ",";

            //Check quyền
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chonVuTach = (CheckBox)item.FindControl("chkChon");
                CheckBox chonDaiDien = (CheckBox)item.FindControl("chkChonDaiDien");

                if (chonDaiDien.Checked)
                {
                    countDaiDien++;
                }
                if (chonVuTach.Checked)
                {
                    count++;
                }
                else
                {
                    donID_DonTach = Convert.ToDecimal(item.Cells[0].Text);
                    //Cộng chuỗi DUONGSU_ID của các đơn chi tiết không được chọn để tách
                    List<DON_DUONGSU_CHITIET> dsCT = dt.DON_DUONGSU_CHITIET
                        .Where(x => x.DONID == DonGocID && x.LOAIAN == 6 && x.DONCHITIETID == donID_DonTach)
                        .ToList(); //KHAI- AHC
                    foreach (var itemCheckDS in dsCT)
                    {
                        strDuongSuDonTachID += itemCheckDS.DUONGSUID + ",";
                    }
                }
                if (countDaiDien > 1)
                {
                    break;
                }
            }

            if (count == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn đơn để tách!";
                cmdTachAn.Focus();
                myCheck = true;
            }
            if (countDaiDien == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn đơn đại diện!";
                cmdTachAn.Focus();
                myCheck = true;
            }
            else if (countDaiDien > 1)
            {
                lbtthongbao.Text = "Bạn chỉ được chọn một đơn đại diện!";
                cmdTachAn.Focus();
                myCheck = true;
            }

            if (!myCheck)
            {
                // Bắt đầu thao tác tách án
                try
                {
                    AHC_DON objDonGoc = dt.AHC_DON.Where(x => x.ID == DonGocID).FirstOrDefault(); //KHAI- AHC
                    AHC_DON objDonMoi = objDonGoc;

                    //Khởi tạo đối tượng đơn chi tiết
                    objDCT = dt.DON_CHITIET.Where(x => x.ID == DonDaiDienID).FirstOrDefault();

                    //Đơn đại diện tách ra tạo thành đơn mới _DON
                    objDonMoi.HINHTHUCNHANDON = objDCT.HINHTHUCNHANDON;
                    objDonMoi.NGAYVIETDON = objDCT.NGAYVIETDON;
                    objDonMoi.NGAYNHANDON = objDCT.NGAYNHANDON;
                    objDonMoi.CANBONHANDONID = objDCT.CANBONHANDONID;
                    objDonMoi.THAMPHANKYNHANDON = objDCT.THAMPHANKYNHANDON;
                    objDonMoi.YEUTONUOCNGOAI = objDCT.YEUTONUOCNGOAI;
                    objDonMoi.LOAIDON = objDCT.LOAIDON;
                    objDonMoi.USERTT_EMAIL = objDCT.USERTT_EMAIL;
                    objDonMoi.USERTT_ID = objDCT.USERTT_ID;
                    objDonMoi.USERTT_NGAYBOSUNG = objDCT.USERTT_NGAYBOSUNG;
                    objDonMoi.USERTT_NGAYGUI = objDCT.USERTT_NGAYGUI;
                    objDonMoi.USERTT_NGAYTAO = objDCT.USERTT_NGAYTAO;
                    objDonMoi.NOIDUNGKHOIKIEN = objDCT.NOIDUNGKHOIKIEN;
                    objDonMoi.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    objDonMoi.NGAYTAO = DateTime.Now;
                    objDonMoi.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    objDonMoi.NGAYSUA = DateTime.Now;

                    AHC_DON_BL dsBL = new AHC_DON_BL(); //KHAI- AHC
                    objDonMoi.TT = dsBL.GETNEWTT((decimal)objDonMoi.TOAANID);
                    objDonMoi.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HANHCHINH + Session[ENUM_SESSION.SESSION_MADONVI] + objDonMoi.TT.ToString(); //KHAI- AHC
                    objDonMoi.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    // update 130825
                    objDonMoi.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    //Danh sách đương sự của đơn chi tiết (đại diện)
                    List<DON_DUONGSU_CHITIET> duongSuCT = dt.DON_DUONGSU_CHITIET
                        .Where(x => x.DONID == DonGocID && x.LOAIAN == 6 && x.DONCHITIETID == DonDaiDienID)
                        .ToList(); //KHAI- AHC

                    AHC_DON_DUONGSU nguyenDonDaiDien = new AHC_DON_DUONGSU(); //KHAI- AHC
                    AHC_DON_DUONGSU biDonDaiDien = new AHC_DON_DUONGSU();

                    foreach (var item in duongSuCT)
                    {
                        AHC_DON_DUONGSU objDS = dt.AHC_DON_DUONGSU.Where(x => x.ID == item.DUONGSUID).FirstOrDefault(); //KHAI- AHC
                        if (objDS.TUCACHTOTUNG_MA == "NGUYENDON" && objDS.ISDAIDIEN_DONCHITIET == 1)
                        {
                            nguyenDonDaiDien = objDS;
                        }
                        else if (objDS.TUCACHTOTUNG_MA == "BIDON" && objDS.ISDAIDIEN_DONCHITIET == 1)
                        {
                            biDonDaiDien = objDS;
                        }
                    }

                    if (nguyenDonDaiDien.ID != 0 && biDonDaiDien.ID != 0)
                    {
                        objDonMoi.TENVUVIEC = nguyenDonDaiDien.TENDUONGSU + " - " + biDonDaiDien.TENDUONGSU + " - " + objDonMoi.QUANHEPHAPLUAT_NAME;

                        dt.AHC_DON.Add(objDonMoi); //KHAI- AHC
                        dt.SaveChanges();

                        //Thêm thông tin vụ việc vào _DON_GIAIDOAN
                        GIAI_DOAN_BL donGD = new GIAI_DOAN_BL();
                        donGD.GAIDOAN_INSERT_UPDATE("6", objDonMoi.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0); //KHAI- AHC

                        //Update bảng _DON_XULY
                        AHC_DON_XULY donXuLy = dt.AHC_DON_XULY.Where(x => x.DON_CHITIETID == DonDaiDienID && x.DON_XULYID == DonGocID).FirstOrDefault(); //KHAI- AHC
                        if (donXuLy != null)
                        {
                            donXuLy.DONID = objDonMoi.ID;
                            donXuLy.DON_CHITIETID = null;
                            donXuLy.DON_XULYID = null;
                        }

                        //Xóa thằng đại diện bảng DON_CHITIET
                        dt.DON_CHITIET.Remove(objDCT);

                        dt.SaveChanges();
                    }
                    else
                    {
                        lbtthongbao.Text = "Đơn đại diện phải là đơn khởi kiện!";
                        cmdTachAn.Focus();
                        myCheck = true;
                    }

                    if (!myCheck)
                    {
                        //Cộng chuỗi DUONGSU_ID của các đương sự vụ gốc
                        List<AHC_DON_DUONGSU> listDS = dt.AHC_DON_DUONGSU.Where(x => x.DONID == DonGocID).ToList(); //KHAI- AHC
                        foreach (var itemListDS in listDS)
                        {
                            if ((itemListDS.ISDONCHITIET == 0 || itemListDS.ISDONCHITIET == null) && (itemListDS.ISDAIDIEN_DONCHITIET == 0 || itemListDS.ISDAIDIEN_DONCHITIET == null) || itemListDS.ISDAIDIEN == 1)
                            {
                                strDuongSuDonTachID += itemListDS.ID + ",";
                            }
                        }

                        //Đơn chi tiết (đơn khởi kiện)
                        foreach (DataGridItem item in dgList.Items)
                        {
                            CheckBox chonVuTach = (CheckBox)item.FindControl("chkChon");
                            if (chonVuTach.Checked)
                            {
                                donID_DonTach = Convert.ToDecimal(item.Cells[0].Text);

                                //Cập nhật danh sách vụ tách
                                if (donID_DonTach != DonDaiDienID)
                                {
                                    //DONID = đơn id của đơn mới vừa thêm bên trên
                                    DON_CHITIET dChiTiet = dt.DON_CHITIET.Where(x => x.ID == donID_DonTach).FirstOrDefault();
                                    dChiTiet.DONID = objDonMoi.ID;

                                    //Update DON_XULYID
                                    AHC_DON_XULY donXuLy = dt.AHC_DON_XULY.Where(x => x.DON_CHITIETID == donID_DonTach && x.DON_XULYID == DonGocID).FirstOrDefault(); //KHAI- AHC
                                    if (donXuLy != null)
                                    {
                                        donXuLy.DON_XULYID = objDonMoi.ID;
                                    }
                                    dt.SaveChanges();

                                    //=================DƯƠNG SỰ ĐƠN CHI TIẾT===============
                                    List<DON_DUONGSU_CHITIET> dsDuongSu = dt.DON_DUONGSU_CHITIET
                                        .Where(x => x.DONID == DonGocID && x.LOAIAN == 6 && x.DONCHITIETID == donID_DonTach)
                                        .ToList(); //KHAI- AHC
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        string tempDuongSuID = "," + itemDS.DUONGSUID + ",";
                                        //Update DONID của danh sách đương sự được tách = DONID đơn đại diện (nếu có án phí thì update DONID án phí của án phí đó)
                                        if (!strDuongSuDonTachID.Contains(tempDuongSuID)) //Nếu đương sự không tồn tại trong danh sách DS của đơn khởi kiện mà không chọn để tách và ds đương dự của vụ gốc
                                        {
                                            //Cập nhật DON_DUONGSU_CHITIET
                                            itemDS.DONID = objDonMoi.ID;

                                            //Cập nhật DONID của _DON_DUONGSU
                                            AHC_DON_DUONGSU donDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.ID == itemDS.DUONGSUID).FirstOrDefault(); //KHAI- AHC
                                            if (donDuongSu != null)
                                            {
                                                donDuongSu.DONID = objDonMoi.ID;
                                                //if (dChiTiet.LOAIDON == 1)
                                                //{
                                                //    donDuongSu.DONID = objDonMoi.ID;
                                                //    donDuongSu.ISDAIDIEN = 0;
                                                //    donDuongSu.ISDONCHITIET = 1;
                                                //    donDuongSu.ISDAIDIEN_DONCHITIET = 1;
                                                //}
                                                //else
                                                //{
                                                //    donDuongSu.DONID = objDonMoi.ID;
                                                //}
                                            }

                                            //Cập nhật án phí
                                            AHC_ANPHI anPhi = dt.AHC_ANPHI.Where(x => x.DONID == DonGocID && x.DUONGSU_ID == itemDS.DUONGSUID).FirstOrDefault(); //KHAI- AHC
                                            if (anPhi != null)
                                            {
                                                anPhi.DONID = objDonMoi.ID;
                                            }

                                            //Update DONID _DON_TAILIEU
                                            AHC_DON_TAILIEU taiLieu = dt.AHC_DON_TAILIEU
                                                .Where(x => x.DONID == DonGocID && x.NGUOIBANGIAO == itemDS.DUONGSUID)
                                                .FirstOrDefault(); //KHAI- AHC

                                            if (taiLieu != null)
                                            {
                                                taiLieu.DONID = objDonMoi.ID;
                                            }

                                            dt.SaveChanges();
                                        }
                                        else
                                        {
                                            //Copy đương sự và không cần update án phí
                                            AHC_DON_DUONGSU donDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.ID == itemDS.DUONGSUID).FirstOrDefault(); //KHAI- AHC
                                            AHC_DON_DUONGSU objDS = donDuongSu;
                                            objDS.DONID = objDonMoi.ID;
                                            //donDuongSu.ISDAIDIEN = 0;
                                            //donDuongSu.ISDONCHITIET = 1;
                                            //donDuongSu.ISDAIDIEN_DONCHITIET = 0;

                                            donDuongSu.ISDAIDIEN_DONCHITIET = donDuongSu.ISDAIDIEN;
                                            donDuongSu.ISDONCHITIET = 1;
                                            donDuongSu.ISDAIDIEN = 0;

                                            dt.AHC_DON_DUONGSU.Add(objDS);
                                            dt.SaveChanges();

                                            //Cập nhật DON_DUONGSU_CHITIET
                                            itemDS.DONID = objDonMoi.ID;
                                            itemDS.DUONGSUID = objDS.ID;

                                            //Copy _DON_TAILIEU
                                            AHC_DON_TAILIEU taiLieu = dt.AHC_DON_TAILIEU
                                                .Where(x => x.DONID == DonGocID && x.NGUOIBANGIAO == itemDS.DUONGSUID)
                                                .FirstOrDefault(); //KHAI- AHC

                                            if (taiLieu != null)
                                            {
                                                AHC_DON_TAILIEU taiLieuCopy = taiLieu; //KHAI- AHC
                                                taiLieuCopy.DONID = objDonMoi.ID;
                                                taiLieuCopy.NGUOIBANGIAO = objDS.ID;
                                                dt.AHC_DON_TAILIEU.Add(taiLieuCopy);
                                            }

                                            dt.SaveChanges();
                                        }
                                    }
                                }
                                else
                                {
                                    //=================DƯƠNG SỰ ĐƠN===================
                                    List<DON_DUONGSU_CHITIET> dsDuongSu = dt.DON_DUONGSU_CHITIET
                                        .Where(x => x.DONID == DonGocID && x.LOAIAN == 6 && x.DONCHITIETID == donID_DonTach)
                                        .ToList(); //KHAI- AHC
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        string tempDuongSuID = "," + itemDS.DUONGSUID + ",";
                                        //Update DONID của danh sách đương sự được tách = DONID đơn đại diện (nếu có án phí thì update DONID án phí của án phí đó)
                                        if (!strDuongSuDonTachID.Contains(tempDuongSuID))
                                        {
                                            //Cập nhật DONID của _DON_DUONGSU
                                            AHC_DON_DUONGSU donDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.ID == itemDS.DUONGSUID).FirstOrDefault(); //KHAI- AHC
                                            if (donDuongSu != null)
                                            {
                                                donDuongSu.DONID = objDonMoi.ID;
                                                donDuongSu.ISDAIDIEN = donDuongSu.ISDAIDIEN_DONCHITIET;
                                                donDuongSu.ISDONCHITIET = 0;
                                                donDuongSu.ISDAIDIEN_DONCHITIET = 0;
                                            }

                                            //Cập nhật án phí
                                            AHC_ANPHI anPhi = dt.AHC_ANPHI
                                                .Where(x => x.DONID == DonGocID && x.DUONGSU_ID == itemDS.DUONGSUID)
                                                .FirstOrDefault(); //KHAI- AHC

                                            if (anPhi != null)
                                            {
                                                anPhi.DONID = objDonMoi.ID;
                                            }
                                            dt.SaveChanges();

                                            //Update DONID _DON_TAILIEU
                                            AHC_DON_TAILIEU taiLieu = dt.AHC_DON_TAILIEU
                                                .Where(x => x.DONID == DonGocID && x.NGUOIBANGIAO == itemDS.DUONGSUID)
                                                .FirstOrDefault(); //KHAI- AHC

                                            if (taiLieu != null)
                                            {
                                                taiLieu.DONID = objDonMoi.ID;
                                            }

                                            //Xóa DON_DUONGSU_CHITIET
                                            dt.DON_DUONGSU_CHITIET.Remove(itemDS);
                                            dt.SaveChanges();
                                        }
                                        else //Copy đương sự và không cần update án phí
                                        {
                                            AHC_DON_DUONGSU donDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.ID == itemDS.DUONGSUID).FirstOrDefault(); //KHAI- AHC
                                            AHC_DON_DUONGSU objDS = donDuongSu;
                                            objDS.DONID = objDonMoi.ID;
                                            objDS.ISDAIDIEN = donDuongSu.ISDAIDIEN_DONCHITIET;
                                            objDS.ISDONCHITIET = 0;
                                            objDS.ISDAIDIEN_DONCHITIET = 0;

                                            dt.AHC_DON_DUONGSU.Add(objDS);
                                            dt.SaveChanges();

                                            //Copy _DON_TAILIEU
                                            AHC_DON_TAILIEU taiLieu = dt.AHC_DON_TAILIEU
                                                .Where(x => x.DONID == DonGocID && x.NGUOIBANGIAO == itemDS.DUONGSUID)
                                                .FirstOrDefault(); //KHAI- AHC

                                            if (taiLieu != null)
                                            {
                                                AHC_DON_TAILIEU taiLieuCopy = taiLieu; //KHAI- AHC
                                                taiLieuCopy.DONID = objDonMoi.ID;
                                                taiLieuCopy.NGUOIBANGIAO = objDS.ID;
                                                dt.AHC_DON_TAILIEU.Add(taiLieuCopy);
                                            }

                                            //Xóa DON_DUONGSU_CHITIET
                                            dt.DON_DUONGSU_CHITIET.Remove(itemDS);
                                            dt.SaveChanges();
                                        }
                                    }
                                }
                            }
                        }

                        //Đơn khác
                        decimal donID_DonKhac = 0;
                        foreach (DataGridItem itemKhac in dgListKhac.Items)
                        {
                            CheckBox chonDonKhac = (CheckBox)itemKhac.FindControl("chkChonKhac");

                            if (chonDonKhac.Checked)
                            {
                                donID_DonKhac = Convert.ToDecimal(itemKhac.Cells[0].Text);

                                //Update DONID
                                DON_KHAC donKhac = dt.DON_KHAC.Where(x => x.ID == donID_DonKhac).FirstOrDefault();
                                donKhac.DONID = objDonMoi.ID;

                                if (donKhac.ISDUONGSU == 1)
                                {
                                    AHC_DON_DUONGSU donKhacDS = dt.AHC_DON_DUONGSU
                                        .Where(x => x.DONID == DonGocID && x.ID == donKhac.DUONGSUID)
                                        .FirstOrDefault(); //KHAI- AHC

                                    if(donKhacDS != null)
                                    {
                                        donKhacDS.DONID = objDonMoi.ID;
                                    }
                                }
                                else if (donKhac.ISDUONGSU == 0)
                                {
                                    AHC_DON_THAMGIATOTUNG donKhacTGTT = dt.AHC_DON_THAMGIATOTUNG
                                        .Where(x => x.DONID == DonGocID && x.ID == donKhac.DUONGSUID)
                                        .FirstOrDefault(); //KHAI- AHC

                                    if(donKhacTGTT != null)
                                    {
                                        donKhacTGTT.DONID = objDonMoi.ID;
                                    }
                                }
                                dt.SaveChanges();
                            }
                        }

                        //Copy sang đơn mới
                        List<AHC_SOTHAM_HDXX> listHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == DonGocID).ToList();
                        AHC_SOTHAM_HDXX hdxx = new AHC_SOTHAM_HDXX(); //KHAI- AHC
                        if (listHDXX != null)
                        {
                            foreach (var item in listHDXX)
                            {
                                hdxx = item;
                                hdxx.DONID = objDonMoi.ID;
                                // update 130825
                                hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.AHC_SOTHAM_HDXX.Add(hdxx);
                                dt.SaveChanges();
                            }
                        }

                        AHC_SOTHAM_THULY thuly = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == DonGocID).FirstOrDefault();
                        if (thuly != null)
                        {
                            AHC_SOTHAM_THULY thuLyDonMoi = thuly; //KHAI- AHC
                            thuLyDonMoi.DONID = objDonMoi.ID;
                            dt.AHC_SOTHAM_THULY.Add(thuLyDonMoi);
                            dt.SaveChanges();
                        }

                        List<AHC_DON_THAMPHAN> listThamPhan = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == DonGocID).ToList();
                        AHC_DON_THAMPHAN thamPhan = new AHC_DON_THAMPHAN(); //KHAI- AHC
                        if (listThamPhan != null)
                        {
                            foreach (var item in listThamPhan)
                            {
                                thamPhan = item;
                                thamPhan.DONID = objDonMoi.ID;
                                // update 130825
                                thamPhan.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.AHC_DON_THAMPHAN.Add(thamPhan);
                                dt.SaveChanges();
                            }
                        }

                        List<AHC_SOTHAM_QUYETDINH> listQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == DonGocID).ToList();
                        AHC_SOTHAM_QUYETDINH quyetDinh = new AHC_SOTHAM_QUYETDINH(); //KHAI- AHC
                        if (listQD != null)
                        {
                            foreach (var item in listQD)
                            {
                                quyetDinh = item;
                                quyetDinh.DONID = objDonMoi.ID;
                                // update 130825
                                quyetDinh.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.AHC_SOTHAM_QUYETDINH.Add(quyetDinh);
                                dt.SaveChanges();
                            }
                        }

                        //Tạo bản ghi DON_NHAPTACH
                        DON_NHAPTACH donNhap = new DON_NHAPTACH();
                        donNhap.DONID = objDonMoi.ID;
                        donNhap.LOAIANID = 6; //KHAI- AHC
                        donNhap.MAVUVIEC = objDonMoi.MAVUVIEC;
                        donNhap.NGUOITAO = objDonMoi.NGUOITAO;
                        donNhap.NGAYTAO = objDonMoi.NGAYTAO;
                        donNhap.VUANGOCID = DonGocID;
                        donNhap.IS_TACHAN = 1;
                        //Lấy chuỗi danh sách đương sự
                        List<AHC_DON_DUONGSU> dsDuongSuDonNhap = dt.AHC_DON_DUONGSU.Where(x => x.DONID == objDonMoi.ID).ToList(); //KHAI- AHC
                        string jsonDuongSu = ",";
                        foreach (var item in dsDuongSuDonNhap)
                        {
                            jsonDuongSu += item.TENDUONGSU + ",";
                        }
                        //Lấy thông tin donNhap.THONGTIN_VUVIEC
                        AHC_DON_BL oBL = new AHC_DON_BL(); //KHAI- AHC
                        DataTable objVuViec = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", objDonMoi.MAVUVIEC, "", "", objDonMoi.TOAANID.ToString(),
                                                        "", "", "", "", "", "", "", "", "", "",
                                                        "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 0, 1, 1);
                        objVuViec.Columns.Remove("STT");
                        objVuViec.Columns.Remove("COUNTALL");
                        //Thay đổi dữ liệu cột HOTENBICAN
                        objVuViec.Rows[0]["HOTENBICAN"] = jsonDuongSu;
                        //Chuyển dữ liệu obj sang json
                        string jsonVuViec = JsonConvert.SerializeObject(objVuViec);
                        donNhap.THONGTIN_VUVIEC = jsonVuViec;
                        //Lấy ds thẩm phán
                        List<AHC_DON_THAMPHAN> dsThamPhan = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == objDonMoi.ID).ToList(); //KHAI- AHC
                        string jsonThamPhan = ",";
                        foreach (var item in dsThamPhan)
                        {
                            jsonThamPhan += item.CANBOID + ",";
                        }
                        //Lấy ds thư kí
                        List<AHC_SOTHAM_HDXX> dsSoThamHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == objDonMoi.ID && x.MAVAITRO == "THUKY").ToList();
                        List<AHC_PHUCTHAM_HDXX> dsPhucThamHDXX = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == objDonMoi.ID && x.MAVAITRO == "THUKY").ToList();
                        string jsonThuKy = ",";
                        foreach (var item in dsSoThamHDXX)
                        {
                            jsonThuKy += item.CANBOID + ",";
                        }
                        foreach (var item in dsPhucThamHDXX)
                        {
                            jsonThuKy += item.CANBOID + ",";
                        }
                        //Lấy thông tin thụ lý
                        AHC_SOTHAM_THULY thuLy = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == objDonMoi.ID).FirstOrDefault(); //KHAI- AHC
                        int ttTL = 0; 
                        string ngayTL = "", soTL = "";
                        if (thuLy != null)
                        {
                            ttTL = 1;
                            ngayTL = String.Format("{0:dd/MM/yyyy}", thuLy.NGAYTHULY);
                            soTL = thuLy.SOTHULY;
                        }
                        else
                        {
                            ttTL = 2;
                        }
                        //Lấy thông tin donNhap.THONGTIN_TIMKIEM
                        Object ttTimKiem = new
                        {
                            TENVUVIEC = objDonMoi.TENVUVIEC,
                            QHPL = objDonMoi.QUANHEPHAPLUAT_NAME,
                            MAVUVIEC = objDonMoi.MAVUVIEC,
                            DUONGSU = jsonDuongSu,
                            CAPXETXU = objDonMoi.MAGIAIDOAN,
                            TOAANID = objDonMoi.TOAANID,
                            TINHTRANGTHULY = ttTL,
                            NGAYTHULY = ngayTL,
                            SOTHULY = soTL,
                            THAMPHANID = jsonThamPhan,
                            THUKYID = jsonThuKy,
                            LOAIDON = objDonMoi.LOAIDON
                        };
                        //Chuyển dữ liệu obj sang json
                        string jsonTimKiem = JsonConvert.SerializeObject(ttTimKiem);
                        donNhap.THONGTIN_TIMKIEM = jsonTimKiem;

                        dt.DON_NHAPTACH.Add(donNhap);
                        dt.SaveChanges();

                        Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
                    }
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Có lỗi khi tách án: " + ex.Message;
                    cmdTachAn.Focus();
                }
            }
        }

        protected void chkChonDaiDien_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox tempCheckBox = (CheckBox)sender;
            TableCell itemData = (TableCell)tempCheckBox.Parent;

            if (tempCheckBox.Checked)
            {
                HiddenField idDaiDien = (HiddenField)itemData.FindControl("hdID");
                DonDaiDienID = Convert.ToDecimal(idDaiDien.Value);
            }
            else
            {
                foreach (DataGridItem item in dgList.Items)
                {
                    CheckBox chonDaiDien = (CheckBox)item.FindControl("chkChonDaiDien");

                    if (chonDaiDien.Checked)
                    {
                        DonDaiDienID = Convert.ToDecimal(item.Cells[0].Text);
                        break;
                    }
                }
            }
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chonVuTach = (CheckBox)item.FindControl("chkChon");
                CheckBox chonDaiDien = (CheckBox)item.FindControl("chkChonDaiDien");

                if (chonVuTach.Checked)
                {
                    HiddenField idDon = (HiddenField)item.FindControl("hdID");
                    decimal idDCT = Convert.ToDecimal(idDon.Value);
                    DON_CHITIET dct = dt.DON_CHITIET.Where(x => x.ID == idDCT).FirstOrDefault();
                    if (dct.LOAIDON == 1)
                    {
                        chonDaiDien.Visible = true;
                    }
                    else
                    {
                        AHC_DON ahcdon = dt.AHC_DON.Where(x => x.ID == idDCT).FirstOrDefault();
                        if (ahcdon.LOAIDON == 1)
                        {
                            chonDaiDien.Visible = true;
                        }
                        else
                        {
                            chonDaiDien.Visible = false;
                            chonDaiDien.Checked = false;
                        }
                    }
                }
                else
                {
                    chonDaiDien.Visible = false;
                    chonDaiDien.Checked = false;
                }
            }
        }
    }
}