using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHS;
using BL.GSTP.QLHS;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.ChuyenNhanAn
{
    public partial class ChuyenAn : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdHuyChuyen, false);
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }

        private void LoadGrid()
        {
            lbthongbao.Text = "";
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vToaNhanID = 0;
            vToaNhanID = hddToaAnNhan.Value == "" ? 0 : Convert.ToDecimal(hddToaAnNhan.Value);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            TongHop_BL oBL = new TongHop_BL();
            string current_id = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.HS_CHUYENAN(vDonViID, txtTenToa.Text.Trim(), txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtSoquyetdinh.Text.Trim(), txtSobanan.Text.Trim(), dFrom, dTo, txtTenduongsu.Text.Trim(), Convert.ToDecimal(rdbTrangthai.SelectedValue));

            #region "Xác định số lượng trang"

            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            #endregion "Xác định số lượng trang"

            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        #endregion "Phân trang"

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void cmdNhanan_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            List<CUS_CHUYENAN_INPUT> data = new List<CUS_CHUYENAN_INPUT>();
            //fill data
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                HiddenField hddLydo = (HiddenField)Item.FindControl("hddLydo");
                HiddenField hddTHGiaoNhan = (HiddenField)Item.FindControl("hddTHGiaoNhan");
                if (chkChon.Checked)
                {
                    CUS_CHUYENAN_INPUT input = new CUS_CHUYENAN_INPUT();
                    input.VuViecID = Item.Cells[0].Text;
                    input.MaVuVien = Item.Cells[1].Text;
                    input.TenVuVien = Item.Cells[4].Text;
                    input.NgayGiao = DateTime.Now.ToString("dd/MM/yyyy");
                    input.ToaGiao = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    input.TruongHopGiaoNhan = hddTHGiaoNhan.Value;
                    input.LyDoId = hddLydo.Value;
                    input.isEnableToaAnTen = true;
                    //hddVuViecID.Value = Item.Cells[0].Text;
                    //txtN_Mavuviec.Text = Item.Cells[1].Text;
                    //txtN_Tenvuviec.Text = Item.Cells[4].Text;
                    //txtN_Ngaygiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    //txtN_Toagiao.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    //txtN_THGN.Text = hddTHGiaoNhan.Value;
                    //hddTHGN.Value = hddLydo.Value;
                    if (hddLydo.Value != "01" && hddLydo.Value != "05")
                    {
                        DM_TOAAN toaAn = null;
                        decimal ToaAnSoThamID = 0, ToaAnCapChaID = 0;

                        ToaAnSoThamID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnSoThamID).FirstOrDefault();
                        if (toaAn != null)
                        {
                            ToaAnCapChaID = toaAn.CAPCHAID == null ? 0 : (decimal)toaAn.CAPCHAID;
                        }

                        if (ToaAnCapChaID == 0)
                        {
                            toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnSoThamID).FirstOrDefault<DM_TOAAN>();
                        }
                        else
                        {
                            toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnCapChaID).FirstOrDefault<DM_TOAAN>();
                        }
                        if (toaAn != null)
                        {
                            input.ToaAn_ID = toaAn.ID.ToString();
                            input.ToaAn_Ten = toaAn.MA_TEN;
                        }
                        input.isEnableToaAnTen = false;
                    }
                    else if (hddLydo.Value == "05")
                    {
                        decimal IDVUAN = Convert.ToDecimal(input.VuViecID);
                        AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == IDVUAN).FirstOrDefault();
                        if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            AHS_CHUYEN_NHAN_AN_BL AHS_CHUYEN_NHAN_AN_BL = new AHS_CHUYEN_NHAN_AN_BL();
                            decimal donIdOld = AHS_CHUYEN_NHAN_AN_BL.getDonIdOld(oDon.ID);
                            AHS_VUAN oDonOld = dt.AHS_VUAN.Where(x => x.ID == donIdOld).FirstOrDefault();
                            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == oDonOld.TOAANID).FirstOrDefault();
                            if (toaAn != null)
                            {
                                input.ToaAn_ID = toaAn.ID.ToString();
                                input.ToaAn_Ten = toaAn.MA_TEN;
                            }
                        }
                        else
                        {
                            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                            if (toaAn != null)
                            {
                                input.ToaAn_ID = toaAn.ID.ToString();
                                input.ToaAn_Ten = toaAn.MA_TEN;
                            }
                        }
                        input.isEnableToaAnTen = false;
                    }
                    else
                    {
                        input.isEnableToaAnTen = true;
                    }
                    data.Add(input);
                }
            }

            rptCapNhat.DataSource = data;
            rptCapNhat.DataBind();
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    HiddenField hddLydo = (HiddenField)Item.FindControl("hddLydo");
            //    HiddenField hddTHGiaoNhan = (HiddenField)Item.FindControl("hddTHGiaoNhan");
            //    if (chkChon.Checked)
            //    {
            //        hddVuViecID.Value = Item.Cells[0].Text;
            //        txtN_Mavuviec.Text = Item.Cells[1].Text;
            //        txtN_Tenvuviec.Text = Item.Cells[4].Text;
            //        txtN_Ngaygiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //        txtN_Toagiao.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            //        txtN_THGN.Text = hddTHGiaoNhan.Value;
            //        hddTHGN.Value = hddLydo.Value;
            //        if (hddTHGN.Value != "01" && hddTHGN.Value != "05")
            //        {
            //            DM_TOAAN toaAn = null;
            //            decimal ToaAnSoThamID = 0, ToaAnCapChaID = 0;

            //            ToaAnSoThamID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //            toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnSoThamID).FirstOrDefault();
            //            if (toaAn != null)
            //            {
            //                ToaAnCapChaID = toaAn.CAPCHAID == null ? 0 : (decimal)toaAn.CAPCHAID;
            //            }

            //            if (ToaAnCapChaID == 0)
            //            {
            //                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnSoThamID).FirstOrDefault<DM_TOAAN>();
            //            }
            //            else
            //            {
            //                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnCapChaID).FirstOrDefault<DM_TOAAN>();
            //            }
            //            if (toaAn != null)
            //            {
            //                hddTN_ID.Value = toaAn.ID.ToString();
            //                txtTN_Ten.Text = toaAn.MA_TEN;
            //            }
            //            txtTN_Ten.Enabled = false;
            //        }
            //        else if (hddTHGN.Value == "05")
            //        {
            //            decimal IDVUAN = Convert.ToDecimal(hddVuViecID.Value);
            //            AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == IDVUAN).FirstOrDefault();
            //            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
            //            if (toaAn != null)
            //            {
            //                hddTN_ID.Value = toaAn.ID.ToString();
            //                txtTN_Ten.Text = toaAn.MA_TEN;
            //            }
            //            txtTN_Ten.Enabled = false;
            //        }
            //        else
            //        {
            //            txtTN_Ten.Enabled = true;
            //        }
            //    }

            //}
            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetButton(cmdNhanan, true);
            Cls_Comon.SetButton(cmdHuyChuyen, true);
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, true);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
            //CheckBox chkXem = (CheckBox)sender;
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    if (chkXem.Checked)
            //    {
            //        if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
            //    }
            //}
        }

        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptCapNhat.Items)
            {
                HiddenField hddVuViecID = (HiddenField)item.FindControl("hddVuViecID");
                decimal VUANID = Convert.ToDecimal(hddVuViecID.Value);
                AHS_VUAN oVuan = dt.AHS_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();
                //Manh Kiem tra neu chua nhap hinh phat cho bi cao thi khong cho chuyen an
                List<AHS_BICANBICAO> LstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VUANID).ToList();
                AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
                bool exitstTDC = false;
                List<AHS_SOTHAM_QUYETDINH_BICAN> QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VUANID).ToList();
                foreach (AHS_SOTHAM_QUYETDINH_BICAN qddcbc in QDBC)
                {
                    DM_QD_QUYETDINH DMQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == qddcbc.QUYETDINHID).FirstOrDefault();
                    if ((DMQD.TEN.Contains("Quyết định đình chỉ") == true) || (DMQD.TEN.Contains("Quyết định tạm đình chỉ") == true))
                    {
                        exitstTDC = true;
                        break;
                    }
                }

                List<AHS_SOTHAM_QUYETDINH_VUAN> QDVA = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID).ToList();
                foreach (AHS_SOTHAM_QUYETDINH_VUAN qddcva in QDVA)
                {
                    DM_QD_QUYETDINH DMQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == qddcva.QUYETDINHID).FirstOrDefault();
                    if ((DMQD.TEN.Contains("Quyết định đình chỉ") == true) || (DMQD.TEN.Contains("Quyết định tạm đình chỉ") == true))
                    {
                        exitstTDC = true;
                        break;
                    }
                }
                for (int i = 0; i < LstBC.Count; i++)
                {
                    try
                    {
                        decimal vcount = 0;
                        decimal vBicaoid = Convert.ToDecimal(LstBC[i].ID);
                        bool checkQD = true;
                        if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                            continue;
                        if (exitstTDC)
                        {
                            checkQD = false;
                        }
                        //List<AHS_SOTHAM_QUYETDINH_BICAN> QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VUANID && x.BICANID == vBicaoid).ToList();
                        //foreach (AHS_SOTHAM_QUYETDINH_BICAN qddcbc in QDBC)
                        //{
                        //    DM_QD_QUYETDINH DMQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == qddcbc.QUYETDINHID).FirstOrDefault();
                        //    if ((DMQD.TEN.Contains("Quyết định đình chỉ") == true) || (DMQD.TEN.Contains("Quyết định tạm đình chỉ") == true))
                        //    {
                        //        checkQD = false;
                        //        break;
                        //    }
                        //}

                        //List<AHS_SOTHAM_QUYETDINH_VUAN> QDVA = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID).ToList();
                        //foreach (AHS_SOTHAM_QUYETDINH_VUAN qddcva in QDVA)
                        //{
                        //    DM_QD_QUYETDINH DMQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == qddcva.QUYETDINHID).FirstOrDefault();
                        //    if ((DMQD.TEN.Contains("Quyết định đình chỉ") == true) || (DMQD.TEN.Contains("Quyết định tạm đình chỉ") == true))
                        //    {
                        //        checkQD = false;
                        //    }`
                        //}

                        if (checkQD == true)
                        {
                            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> tbl = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.VUANID == VUANID && x.BICANID == vBicaoid).ToList();

                            if (tbl.Count > 0)
                            {
                                for (int j = 0; j < tbl.Count; j++)
                                {
                                    if (tbl[j].HINHPHATID > 0)
                                        vcount++;
                                }
                                if (vcount == 0)
                                {
                                    lbthongbaoNA.Text = "Bạn chưa nhập hình phạt cho bị cáo!";
                                    return;
                                }
                            }
                            else
                            {
                                lbthongbaoNA.Text = "Bạn chưa nhập hình phạt cho bị cáo!";
                                return;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lbthongbaoNA.Text = ex.Message;
                        return;
                    }
                }
                DropDownList txtTN_Ten = (DropDownList)item.FindControl("txtTN_Ten");
                if (txtTN_Ten.SelectedValue == "" || txtTN_Ten.SelectedValue == "0")
                {
                    lbthongbaoNA.Text = "Bạn chưa chọn tòa án cần chuyển !";
                    txtTN_Ten.Focus();
                    return;
                }
            }
            foreach (RepeaterItem item in rptCapNhat.Items)
            {
                //HiddenField hddTN_ID = (HiddenField)item.FindControl("hddTN_ID");
                HiddenField hddVuViecID = (HiddenField)item.FindControl("hddVuViecID");
                HiddenField hddTHGN = (HiddenField)item.FindControl("hddTHGN");
                //Label lbthongbaoNA = (Label)item.FindControl("lbthongbaoNA");
                DropDownList txtTN_Ten = (DropDownList)item.FindControl("txtTN_Ten");
                TextBox txtN_Ngaygiao = (TextBox)item.FindControl("txtN_Ngaygiao");
                TextBox txtTN_ghichu = (TextBox)item.FindControl("txtTN_ghichu");
                try
                {
                    if (txtTN_Ten.SelectedValue == "" || txtTN_Ten.SelectedValue == "0")
                    {
                        lbthongbaoNA.Text = "Bạn chưa chọn tòa án cần chuyển !";
                        txtTN_Ten.Focus();
                        return;
                    }
                    decimal VUANID = Convert.ToDecimal(hddVuViecID.Value);
                    AHS_CHUYEN_NHAN_AN oND = new AHS_CHUYEN_NHAN_AN();
                    oND.VUANID = VUANID;
                    oND.TOACHUYENID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.TOANHANID = Convert.ToDecimal(txtTN_Ten.SelectedValue);
                    oND.NGAYGIAO = (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    DM_DATAGROUP oG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();

                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.GROUPID == oG.ID && x.MA == hddTHGN.Value).FirstOrDefault();
                    oND.TRUONGHOPGIAONHANID = oIT.ID;
                    oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    oND.GHICHU_GIAO = txtTN_ghichu.Text;
                    oND.TRANGTHAI = 0;// 0: Chuyển chờ nhận, 1: Nhận
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.NGAYTAO = DateTime.Now;
                    // insert toa_gq_id
                    if(oND.TOA_GIAIQUYET_ID == null)
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_CHUYEN_NHAN_AN.Add(oND);
                    dt.SaveChanges();

                    #region toancau-anhnt map chuyển nhận án với kháng cáo kháng nghị sơ thẩm

                    List<AHS_SOTHAM_KHANGCAO> oKcs = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VUANID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).ToList();
                    if (oKcs != null && oKcs.Count > 0)
                    {
                        foreach (var oKc in oKcs)
                        {
                            var mapKc = DataExtensions.GetAllWithClause<AHS_CHUYEN_NHAN_AN_KCKN>($"KCKNID ={oKc.ID} AND ISKC = 1").FirstOrDefault();
                            if (mapKc == null)
                            {
                                mapKc = new AHS_CHUYEN_NHAN_AN_KCKN()
                                {
                                    ISKC = 1,
                                    CHUYENNHANID = oND.ID,
                                    KCKNID = oKc.ID
                                };
                                DataExtensions.Insert(mapKc);
                            }
                        }
                    }
                    List<AHS_SOTHAM_KHANGNGHI> oKns = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VUANID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).ToList();
                    if (oKns != null && oKns.Count > 0)
                    {
                        foreach (var oKn in oKns)
                        {
                            var mapKc = DataExtensions.GetAllWithClause<AHS_CHUYEN_NHAN_AN_KCKN>($"KCKNID ={oKn.ID} AND ISKC = 0").FirstOrDefault();
                            if (mapKc == null)
                            {
                                mapKc = new AHS_CHUYEN_NHAN_AN_KCKN()
                                {
                                    ISKC = 0,
                                    CHUYENNHANID = oND.ID,
                                    KCKNID = oKn.ID
                                };
                                DataExtensions.Insert(mapKc);
                            }
                        }
                    }

                    #endregion toancau-anhnt map chuyển nhận án với kháng cáo kháng nghị sơ thẩm

                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";

                    //10092021 insert quản lý hồ sơ trạng thái kháng nghị kháng cáo
                    new QLHS_BL().InsertHoSoLuTruCoChuyenAn(VUANID, ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault), 4, (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""), oND.TOANHANID, txtTN_Ten.SelectedItem.Text);

                    LoadGrid();
                    lbthongbaoNA.Text = "Hoàn thành chuyển án !";
                    pnDanhsach.Visible = true;
                    pnCapnhat.Visible = false;
                }
                catch (Exception ex)
                {
                    lbthongbaoNA.Text = "Lỗi: " + ex.Message;
                }
            }
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    Literal lstNgaythuly = (Literal)e.Item.FindControl("lstNgaythuly");
                    //Literal lstSoQDBA = (Literal)e.Item.FindControl("lstSoQDBA");
                    Literal lstNoiDung = (Literal)e.Item.FindControl("lstNoiDung");
                    HiddenField hddLydo = (HiddenField)e.Item.FindControl("hddLydo");
                    HiddenField hddTHGiaoNhan = (HiddenField)e.Item.FindControl("hddTHGiaoNhan");
                    CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                    string strID = e.Item.Cells[0].Text, strNoiDung = "";
                    decimal ID = Convert.ToDecimal(strID), MaGiaiDoan = 0;
                    AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                    if (oDon != null)
                    {
                        MaGiaiDoan = oDon.MAGIAIDOAN + "" == "" ? 0 : (decimal)oDon.MAGIAIDOAN;
                    }
                    if (MaGiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM || MaGiaiDoan == ENUM_GIAIDOANVUAN.HOSO)
                    {
                        AHS_SOTHAM_THULY oTL = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                        if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                        if (rdbTrangthai.SelectedValue == "0")
                        {
                            bool flag = false;

                            List<AHS_SOTHAM_KHANGCAO> lstkc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == ID && (x.TINHTRANG_GIAIQUYET != 1 && x.TINHTRANG_GIAIQUYET != 2)).OrderBy(y => y.ISQUAHAN).ToList();
                            List<AHS_SOTHAM_KHANGNGHI> lstkn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == ID && (x.TINHTRANG_GIAIQUYET != 1 && x.TINHTRANG_GIAIQUYET != 3)).ToList();
                            AHS_SOTHAM_KHANGCAO okc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == ID).OrderByDescending(y => y.ISQUAHAN).FirstOrDefault();
                            // AHS_SOTHAM_KHANGNGHI okn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == ID).FirstOrDefault();
                            if (lstkc.Count > 0 && lstkn.Count > 0)
                            {
                                //lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                                //lstSoQDBA.Text += "<br/>" + lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGCAO_KHANGNGHI_PHUCTHAM;
                                //strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm";

                                if (okc.ISQUAHAN == 1)
                                    strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm <b><span style='color: red'>(KC quá hạn)</span></b>";
                                else
                                    strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm";
                            }
                            else if (lstkc.Count > 0 && lstkn.Count == 0)
                            {
                                //lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGCAO_PHUCTHAM;
                                if (okc.ISQUAHAN == 1)
                                    if (okc.GQ_TINHTRANG == 1)
                                    {
                                        strNoiDung = "Do có kháng cáo phúc thẩm <b><span style='color: red'>(KC quá hạn đã duyệt)</span></b>";
                                        chkChon.Enabled = true;
                                    }
                                    else
                                    {
                                        strNoiDung = "Do có kháng cáo phúc thẩm <b><span style='color: red'>(KC quá hạn chưa duyệt)</span></b>";
                                        //manhnd them chỉ cần có 1 kháng cáo đúng hạn là cho chuyển
                                        decimal ck = 0;
                                        foreach (var item in lstkc)
                                        {
                                            if (item.ISQUAHAN == 0)
                                                ck = 1;
                                            break;
                                        }
                                        if (ck == 0)
                                            chkChon.Enabled = false;
                                    }
                                else
                                    strNoiDung = "Do có kháng cáo phúc thẩm";
                            }
                            else if (lstkc.Count == 0 && lstkn.Count > 0)
                            {
                                //lstSoQDBA.Text = lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGNGHI_PHUCTHAM;
                                strNoiDung = "Do có kháng nghị phúc thẩm";
                            }

                            if (flag == false)
                            {
                                DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.Where(x => x.MA == "CVA").FirstOrDefault();
                                if (oDMQD != null)
                                {
                                    decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                                    AHS_SOTHAM_QUYETDINH_VUAN oQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == ID
                                                                                                           && x.LOAIQDID == oDMQD.ID
                                                                                                           && x.DONVIID == IDToa).OrderByDescending(y => y.NGAYQD).FirstOrDefault();
                                    if (oQD != null)
                                    {
                                        //lstSoQDBA.Text = oQD.SOQD + " - " + ((DateTime)oQD.NGAYQD).ToString("dd/MM/yyyy");
                                        hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU;
                                        strNoiDung = "Không thuộc thẩm quyền xét xử";
                                        flag = true;
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (hddLydo.Value != "")
                            {
                                decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                                DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                                strNoiDung = oIT.TEN;
                            }
                        }
                    }
                    else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM)
                    {
                        AHS_PHUCTHAM_THULY oTL = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                        if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                        if (rdbTrangthai.SelectedValue == "0")
                        {
                            //DM_KETQUA_PHUCTHAM oKQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.MA == "06").FirstOrDefault();
                            //List<AHS_PHUCTHAM_BANAN> lstba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == ID && x.KETQUAPHUCTHAMID == oKQPT.ID).ToList();
                            //DM_KETQUA_PHUCTHAM oKQPT2 = dt.DM_KETQUA_PHUCTHAM.Where(x => x.MA == "04").FirstOrDefault();
                            //List<AHS_PHUCTHAM_BANAN> lstba2 = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == ID && x.KETQUAPHUCTHAMID == oKQPT2.ID).ToList();
                            //if (lstba.Count > 0 || lstba2.Count >0)
                            //{
                            //    //lstSoQDBA.Text = lstba[0].SOBANAN + " - " + ((DateTime)lstba[0].NGAYTUYENAN).ToString("dd/MM/yyyy");
                            //    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                            //    strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                            //}

                            List<AHS_PHUCTHAM_BANAN> lstba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == ID && (x.KETQUAPHUCTHAMID == 4 || x.KETQUAPHUCTHAMID == 22)).ToList();
                            //List<AHS_PHUCTHAM_QUYETDINH_VUAN> lstqd = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
                            if (lstba.Count > 0)// || lstqd.Count > 0)
                            {
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                            }
                        }
                        else
                        {
                            if (hddLydo.Value != "")
                            {
                                decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                                DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                                strNoiDung = oIT.TEN;
                                //List<AHS_PHUCTHAM_BANAN> lstba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == ID).ToList();
                                //if (lstba.Count > 0)
                                //{
                                //    lstSoQDBA.Text = lstba[0].SOBANAN + " - " + ((DateTime)lstba[0].NGAYTUYENAN).ToString("dd/MM/yyyy");
                                //}
                            }
                        }
                    }
                    else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                    {
                        AHS_KCKNQDK_PHUCTHAM_THULY oTL = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {ID}").OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                        if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                        if (rdbTrangthai.SelectedValue == "0")
                        {
                            //List<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN> lstqd = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>($"VUANID = {ID} AND QUYETDINHID IN (127,203,304)" ).ToList();
                            //if (lstqd.Count > 0)// || lstqd.Count > 0)
                            //{
                            //    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                            //    strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                            //}

                            List<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN> lstqd = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>($"VUANID = {ID} AND KETQUAID IN (101,102,103)");
                            if (lstqd.Count > 0)
                            {
                                var qd = lstqd.FirstOrDefault();
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;

                                strNoiDung = qd.KETQUAID == 101 ?
                                    "Giữ nguyên quyết định của Tòa án cấp sơ thẩm" :
                                    (qd.KETQUAID == 102 ?
                                    "Sửa quyết định của Tòa án cấp sơ thẩm" :
                                    "Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án");
                            }
                            else
                            {
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                strNoiDung = "Đình chỉ giải quyết phúc thẩm đối với KC/KN QĐ TĐC của tòa án cấp sơ thẩm";
                            }
                        }
                        else
                        {
                            if (hddLydo.Value != "")
                            {
                                decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                                DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                                strNoiDung = oIT.TEN;
                                //List<AHS_PHUCTHAM_BANAN> lstba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == ID).ToList();
                                //if (lstba.Count > 0)
                                //{
                                //    lstSoQDBA.Text = lstba[0].SOBANAN + " - " + ((DateTime)lstba[0].NGAYTUYENAN).ToString("dd/MM/yyyy");
                                //}
                            }
                        }
                    }
                    hddTHGiaoNhan.Value = strNoiDung;
                    lstNoiDung.Text = "<b>- Lý do:</b> " + strNoiDung + "<br/>" + rv["v_NOIDUNG"];

                    LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                    //------------------
                    Literal lttChitiet = (Literal)e.Item.FindControl("lttChitiet");
                    lttChitiet.Text = "<a  style='color: red; font - weight:bold;' href='javascript:;' onclick='popup_chitiet(" + rv["V_VUANID"].ToString() + ',' + rv["V_MAVUAN"].ToString() + ");'>Chi tiết >></a>";

                    if (rdbTrangthai.SelectedValue == "1")
                        lbtHuyChuyen.Visible = true;
                    else
                        lbtHuyChuyen.Visible = false;
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Lỗi: " + ex.Message;
                }
            }
        }

        protected void rdbTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void cmdHuyChuyen_Click(object sender, EventArgs e)
        {
            try
            {
                List<decimal> lstCHUYENANID = new List<decimal>();
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        var CHUYENANID = Convert.ToDecimal(chkChon.ToolTip);
                        lstCHUYENANID.Add(CHUYENANID);
                        //break;
                    }
                }

                HuyChuyen(lstCHUYENANID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal CHUYENANID = Convert.ToDecimal(e.CommandArgument.ToString());
                List<decimal> lstCHUYENANID = new List<decimal>();
                lstCHUYENANID.Add(CHUYENANID);
                switch (e.CommandName)
                {
                    case "HuyChuyen":
                        HuyChuyen(lstCHUYENANID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void HuyChuyen(List<decimal> lstCHUYENANID)
        {
            AHS_CHUYEN_NHAN_AN_BL Bl = new AHS_CHUYEN_NHAN_AN_BL();
            for (int i = 0; i < lstCHUYENANID.Count; i++)
            {
                var Id = lstCHUYENANID[i];
                AHS_CHUYEN_NHAN_AN ObjChuyenNhan = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.ID == Id).FirstOrDefault();
                if (ObjChuyenNhan.TRANGTHAI == 1)
                {
                    string Result = "Án đã được ";
                    DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjChuyenNhan.TOANHANID).FirstOrDefault();
                    if (ObjToaAn != null)
                    {
                        Result += ObjToaAn.MA_TEN;
                    }
                    Result += " nhận. Không được phép hủy chuyển án.";
                    lbthongbao.Text = Result;
                    return;
                }
            }
            // Án chưa được nhận mới cho phép hủy chuyển án.
            for (int i = 0; i < lstCHUYENANID.Count; i++)
            {
                var CHUYENANID = lstCHUYENANID[i];
                string Message_Ex = "Không được phép hủy chuyển án.";
                AHS_CHUYEN_NHAN_AN ObjChuyenNhan = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.ID == CHUYENANID).FirstOrDefault();
                decimal VUANID = ObjChuyenNhan.VUANID.Value;
                if (ObjChuyenNhan != null)
                {
                    if (ObjChuyenNhan.TRANGTHAI != 1) // Án chưa nhận
                    {
                        #region toancau-anhnt xoá map chuyển nhận án và kháng cáo, kháng nghị

                        List<AHS_CHUYEN_NHAN_AN_KCKN> mapKcKn = DataExtensions.GetAllWithClause<AHS_CHUYEN_NHAN_AN_KCKN>($"CHUYENNHANID={ObjChuyenNhan.ID}").ToList();
                        if (mapKcKn != null && mapKcKn.Count > 0)
                        {
                            foreach (var map in mapKcKn)
                            {
                                DataExtensions.Delete(map);
                            }
                        }

                        #endregion toancau-anhnt xoá map chuyển nhận án và kháng cáo, kháng nghị

                        dt.AHS_CHUYEN_NHAN_AN.Remove(ObjChuyenNhan);
                        dt.SaveChanges();
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        //10092021 insert quản lý hồ sơ trạng thái kháng nghị kháng cáo

                        new QLHS_BL().DeleteHoSoLuTruCoChuyenAn(VUANID, ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);

                        //manhnd 10/12/2021 cap nhat lai MAGIAIDON sau khi huy chuyen
                        AHS_VUAN_GIAIDOAN oGD = dt.AHS_VUAN_GIAIDOAN.Where(x => x.VUANID == VUANID && x.TOAANID == ObjChuyenNhan.TOACHUYENID).FirstOrDefault();

                        AHS_VUAN oDon = dt.AHS_VUAN.Where(X => X.ID == VUANID).FirstOrDefault();
                        if (oGD == null)
                        {
                            oGD = dt.AHS_VUAN_GIAIDOAN.Where(x => x.VUANID == VUANID && x.TOAPHUCTHAMID == ObjChuyenNhan.TOACHUYENID).FirstOrDefault();
                        }
                        oDon.MAGIAIDOAN = oGD.MAGIAIDOAN;
                        dt.SaveChanges();
                        dt.SaveChanges();
                    }
                    else
                    {
                        string Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjChuyenNhan.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. Không được phép hủy chuyển án.";
                        lbthongbao.Text = Result;
                        return;
                    }
                }
            }

            LoadGrid();
            lbthongbao.Text = "Hủy chuyển án thành công.";
        }

        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

            var hddVuViecIDCurrent = e.Item.FindControl("hddVuViecID") as HiddenField;
            var hddTN_ID = e.Item.FindControl("hddTN_ID") as HiddenField;
            var isEnableToaAnTen = e.Item.FindControl("isEnableToaAnTen") as HiddenField;
            var hddTHGN = e.Item.FindControl("hddTHGN") as HiddenField;
            DropDownList selectList = e.Item.FindControl("txtTN_Ten") as DropDownList;
            Label lbthongbaoCA = e.Item.FindControl("lbthongbaoCA") as Label;
            var hddMaVuViec = e.Item.FindControl("hddMaVuViec") as HiddenField;

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                selectList.Items.Clear();
                selectList.Enabled = true;
                //set lại dropdowlist
                DM_TOAAN toaAn = new DM_TOAAN();
                decimal toaanST = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal toacapchaID = 0;
                toaAn = dt.DM_TOAAN.Where(x => x.ID == toaanST && x.HIEULUC == 1).FirstOrDefault();
                if (toaAn != null)
                {

                    toacapchaID = toaAn.CAPCHAID == null ? 0 : (decimal)toaAn.CAPCHAID;
                }
                if (toacapchaID == 0)
                {
                    toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toaanST).FirstOrDefault<DM_TOAAN>();
                }
                else
                {
                    toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toacapchaID).FirstOrDefault<DM_TOAAN>();


                }



                //List<string> arr = new List<string>();

                if (!string.IsNullOrEmpty(hddTN_ID.Value))
                {
                    toacapchaID = Convert.ToDecimal(hddTN_ID.Value);
                    toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toacapchaID).FirstOrDefault<DM_TOAAN>();
                    BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    DataTable dtSapNhap = bl.GETS_BY_TOAANTID(Convert.ToDecimal(hddTN_ID.Value));

                    if (dtSapNhap != null)
                    {
                        for (int i = 0; i < dtSapNhap.Rows.Count; i++)
                        {
                            if (dtSapNhap.Rows[i]["HIEULUC"].ToString() == "1")
                                if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == Convert.ToDecimal(hddTN_ID.Value))
                                    selectList.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                                else
                                    selectList.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                        }

                    }
                    if (toaAn != null)
                        selectList.Items.Insert(0, new ListItem(toaAn.TEN, toaAn.ID.ToString()));
                    selectList.SelectedValue = hddTN_ID.Value;
                }
                else
                {
                    if (toaAn != null)
                        selectList.Items.Insert(0, new ListItem(toaAn.TEN, toaAn.ID.ToString()));
                }
                if (isEnableToaAnTen.Value == "False")
                {

                    //selectList.Enabled = false;
                }
                else
                {

                    DM_TOAAN_BL obj = new DM_TOAAN_BL();
                    DataTable tbl = obj.SearchTop(10000000, "");
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                        {
                            if (row["ID"].ToString() != toaAn.ID.ToString())
                            {
                                selectList.Items.Add(new ListItem(row["MA_TEN"].ToString(), row["ID"].ToString()));
                            }

                            //arr.Add(row["ID"].ToString() + "_" + row["MA_TEN"]);
                        }
                    }

                }
                if (hddTHGN.Value == "05")
                {
                    decimal DONID = Convert.ToDecimal(hddVuViecIDCurrent.Value);
                    string mavuviec = hddMaVuViec.Value;
                    AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                    int temp = 0;
                    if (oDon != null && oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                    {
                        AHS_VUAN oDonST = dt.AHS_VUAN.Where(x => x.MAVUAN == mavuviec && x.TOAANID != toaanST).FirstOrDefault();
                        foreach (ListItem item in selectList.Items)
                        {
                            if (Convert.ToDecimal(item.Value) == oDonST.TOAANID)
                            {
                                selectList.SelectedValue = item.Value;
                                selectList.Enabled = false;
                                temp++;
                                break;
                                // selectList.Items.Remove(item);
                            }
                        }
                        if (temp == 0)
                        {
                            lbthongbaoCA.Text = "Tòa sơ thẩm nhận án đã bị tắt hiệu lực";
                            selectList.Items.Clear();
                            // dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toacapchaID).FirstOrDefault<DM_TOAAN>();
                        }
                    }
                }


            }
        }
    }
}