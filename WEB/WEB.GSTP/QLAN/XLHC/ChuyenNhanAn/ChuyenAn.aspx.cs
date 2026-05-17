using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.XLHC.KCKN;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.ChuyenNhanAn
{
    public partial class ChuyenAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdHuyChuyen, false);
                }
            }
            catch (Exception ex) {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);

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
            DataTable oDT;
            oDT = oBL.XLHC_CHUYENAN_V2(vDonViID, txtTenToa.Text.Trim(), txtMaVuViec.Text, txtTenVuViec.Text, txtSoquyetdinh.Text, "", dFrom, dTo, txtTenduongsu.Text, Convert.ToDecimal(rdbTrangthai.SelectedValue));


            #region "Xác định số lượng trang"
            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
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
        #endregion

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
                    if (hddTHGiaoNhan.Value != null)
                    {
                        input.TruongHopGiaoNhan = hddTHGiaoNhan.Value;
                    }
                    else
                    {
                        input.TruongHopGiaoNhan = "Không có thẩm quyền giải quyết";
                    }

                    input.LyDoId = hddLydo.Value;
                    input.isEnableToaAnTen = true;
                    decimal IDVUAN = Convert.ToDecimal(input.VuViecID);

                    if (hddLydo.Value != "01" && hddLydo.Value != "05")
                    {
                        DM_TOAAN toaAn = null;
                        decimal ToaAnSoThamID = 0, ToaAnCapChaID = 0;

                        decimal donId = Convert.ToDecimal(Item.Cells[0].Text);

                        XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == donId).FirstOrDefault();

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
                            if (toaAn.ID == oDon.TOAPHUCTHAMID)
                            {
                                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                            }
                            else
                            {
                                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnCapChaID).FirstOrDefault<DM_TOAAN>();
                            }

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
                        decimal donId = Convert.ToDecimal(Item.Cells[0].Text);
                        XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == donId).FirstOrDefault();
                        if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            XLHC_CHUYEN_NHAN_AN_BL xLHC_CHUYEN_NHAN_AN_BL = new XLHC_CHUYEN_NHAN_AN_BL();
                            decimal donIdOld = xLHC_CHUYEN_NHAN_AN_BL.getDonIdOld(oDon.ID);
                            XLHC_DON oDonOld = dt.XLHC_DON.Where(x => x.ID == donIdOld).FirstOrDefault();
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
            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetButton(cmdNhanan, true);
            Cls_Comon.SetButton(cmdHuyChuyen, true);
            CheckBox chkXem = (CheckBox)sender;
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, true);
                /*                string v_VUANID = chkXem.ToolTip; // Lấy giá trị v_VUANID từ ToolTip
                                                                  // Nếu cần kiểu số:
                                decimal vuanId = 0;
                                decimal.TryParse(v_VUANID, out vuanId);
                                XLHC_CHUYEN_NHAN_AN_BL xlhc_chuyen_nhan_an = new XLHC_CHUYEN_NHAN_AN_BL();
                                if(xlhc_chuyen_nhan_an.CheckCoKnDuocChapNhan(vuanId))
                                {
                                    Cls_Comon.SetButton(cmdNhanan, true);
                                } else
                                {
                                    Cls_Comon.SetButton(cmdNhanan, false);
                                }*/
                Cls_Comon.SetButton(cmdHuyChuyen, false);

            }

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkXem.Checked)
                {
                    if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
                }
            }
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptCapNhat.Items)
            {
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
                HiddenField hddVuViecID = (HiddenField)item.FindControl("hddVuViecID");
                HiddenField hddTHGN = (HiddenField)item.FindControl("hddTHGN");
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
                    decimal DONID = Convert.ToDecimal(hddVuViecID.Value);
                    XLHC_CHUYEN_NHAN_AN oND = new XLHC_CHUYEN_NHAN_AN();
                    oND.VUANID = DONID;
                    oND.TOACHUYENID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.TOANHANID = Convert.ToDecimal(txtTN_Ten.SelectedValue);
                    oND.NGAYGIAO = (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    DM_DATAGROUP oG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();

                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.GROUPID == oG.ID && x.MA == hddTHGN.Value).FirstOrDefault();
                    oND.TRUONGHOPGIAONHANID = oIT.ID;
                    oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    oND.GHICHU_GIAO = txtTN_ghichu.Text;
                    oND.TRANGTHAI = 0;// 0: Chuyển chờ nhận, 1: Nhận
                    oND.NGAYTAO = DateTime.Now;
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                    dt.XLHC_CHUYEN_NHAN_AN.Add(oND);

                    dt.SaveChanges();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
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
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            try
            {
                listChuyenAnSoTham(sender, e);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        private void listChuyenAnSoTham(object sender, DataGridItemEventArgs e)
        {
            var rv = (DataRowView)e.Item.DataItem;
            var lstNgaythuly = (Literal)e.Item.FindControl("lstNgaythuly");
            var lstNoiDung = (Literal)e.Item.FindControl("lstNoiDung");
            var hddLydo = (HiddenField)e.Item.FindControl("hddLydo");
            var chkChon = (CheckBox)e.Item.FindControl("chkChon");
            HiddenField hddTHGiaoNhan = (HiddenField)e.Item.FindControl("hddTHGiaoNhan");

            string strID = e.Item.Cells[0].Text, strNoiDung = "";
            decimal ID = Convert.ToDecimal(strID), MaGiaiDoan = 0;


            XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oDon != null)
            {
                MaGiaiDoan = oDon.MAGIAIDOAN + "" == "" ? 0 : (decimal)oDon.MAGIAIDOAN;
            }
            if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM)
            {
                XLHC_PHUCTHAM_THULY oTL = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
            }
            else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
            {
                XLHC_KCKNQDK_PHUCTHAM_THULY oTL = DataExtensions.GetAllByDonId<XLHC_KCKNQDK_PHUCTHAM_THULY>(ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
            }
            else
            {
                XLHC_SOTHAM_THULY oTL = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).FirstOrDefault();
                if (oTL != null) lstNgaythuly.Text = oTL.NGAYTHULY?.ToString("dd/MM/yyyy");
            }

            if (rdbTrangthai.SelectedValue == "0")
            {
                DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.FirstOrDefault(x => x.MA == "CVA");
                if (oDMQD != null)
                {
                    decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    var oQD = dt.XLHC_SOTHAM_QUYETDINH
                        .Where(x => x.DONID == ID && x.LOAIQDID == oDMQD.ID && x.TOAANID == IDToa)
                        .OrderByDescending(y => y.NGAYQD)
                        .FirstOrDefault();
                    if (oQD != null)
                    {
                        hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU;
                        lstNoiDung.Text = "Không thuộc thẩm quyền xét xử";
                        return;
                    }
                }

                // Gọi hàm xử lý kháng cáo/phúc thẩm
                string lyDo, noiDung;
                bool choPhepChon;
                XuLyKhangCaoVaPhucTham(ID, out lyDo, out noiDung, out choPhepChon);

                hddLydo.Value = lyDo;
                strNoiDung = noiDung;
                chkChon.Enabled = choPhepChon;
            }
            else
            {
                if (hddLydo.Value != "")
                {
                    decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                    strNoiDung = oIT.TEN;
                    // neu co an khong qua han thi duoc chuyen an
                    // 310725: bỏ qua các KCKN TĐC đã giải quyết
                    var lstKN = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.GQ_TINHTRANG != 3).ToList();
                    bool coKhangCaoDungHan = lstKN.Any(x => x.ISQUAHAN == 0);
                    bool tatCaKNDungHan = lstKN.All(x => x.ISQUAHAN == 0);
                    // 310725: bỏ qua các KCKN TĐC đã giải quyết
                    XLHC_SOTHAM_KHANGCAO oKN = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.GQ_ISCHAPNHAN == 1 && x.GQ_TINHTRANG != 3).FirstOrDefault();
                    decimal ToaAnSoThamID = 0;
                    ToaAnSoThamID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnSoThamID).FirstOrDefault();
                    if (!coKhangCaoDungHan)
                    {
                        // Kiểm tra ISQUAHAN = 1 và có đang ở màn chuyển án ST hay k
                        if (oKN != null && toaAn.LOAITOA == "CAPHUYEN")
                        {
                            strNoiDung += " <b><span style='color: red'>(KN quá hạn đã duyệt)</span></b>";
                        }
                    }
                    else
                    {
                        if (!tatCaKNDungHan)
                        {
                            if (toaAn.LOAITOA == "CAPHUYEN")
                            {
                                if (oKN == null)
                                {
                                    strNoiDung += " <b><span style='color: red'>(KN quá hạn chưa duyệt)</span></b>";
                                }
                                else
                                {
                                    strNoiDung += " <b><span style='color: red'>(KN quá hạn đã duyệt)</span></b>";
                                }
                            }
                        }
                    }

                    //List<XLHC_SOTHAM_KHANGCAO> lstkc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID).ToList();
                    //List<XLHC_SOTHAM_KHANGNGHI> lstkn = dt.XLHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID).ToList();
                    //if (lstkc.Count > 0 && lstkn.Count > 0)
                    //{
                    //    lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                    //    lstSoQDBA.Text += "<br/>" + lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                    //}
                    //else if (lstkc.Count > 0 && lstkn.Count == 0)
                    //{
                    //    lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                    //}
                    //else if (lstkc.Count == 0 && lstkn.Count > 0)
                    //{
                    //    lstSoQDBA.Text = lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                    //}
                }
            }

            lstNoiDung.Text = "<b>- Lý do:</b> " + strNoiDung + "<br/>" + rv["v_NOIDUNG"];
            hddTHGiaoNhan.Value = strNoiDung;

            LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
            if (rdbTrangthai.SelectedValue == "1")
                lbtHuyChuyen.Visible = true;
            else
                lbtHuyChuyen.Visible = false;
        }

        private void XuLyKhangCaoVaPhucTham(decimal donId, out string lyDo, out string noiDung, out bool enableCheckBox)
        {

            XLHC_PHUCTHAM_BANAN ptBa = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == donId).FirstOrDefault();

            lyDo = string.Empty;
            noiDung = string.Empty;
            enableCheckBox = true;

            string noiDungBase = "";

            if (ptBa != null)
            {
                XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == donId).FirstOrDefault();
                if (oDon != null && oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;

                }
                else
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.HUYQD_CHUYENHOSO;
                }
                noiDungBase = "Hủy QĐ và chuyển hồ sơ để xem xét, giải quyết lại";
                if (!string.IsNullOrEmpty(noiDungBase))
                {
                    if (ptBa.TK_ISQUAHAN == 1)
                    {
                        noiDung = $"{noiDungBase} <b><span style='color: red'>(QĐ quá hạn)</span></b>";
                        enableCheckBox = true;
                    }
                    else
                    {
                        noiDung = noiDungBase;
                    }
                }
            }
            else
            {
                // 310725: bỏ qua các KCKN TĐC đã giải quyết
                var lstKN = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == donId && x.GQ_TINHTRANG != 3).ToList();
                var lstKhieuNai = lstKN.Where(x => x.TYPE == 1).ToList();
                var lstKienNghi = lstKN.Where(x => x.TYPE == 2).ToList();
                var lstKhangNghi = lstKN.Where(x => x.TYPE == 3).ToList();
                var okc = lstKN.OrderByDescending(y => y.ISQUAHAN).FirstOrDefault();

                bool isQuaHan = okc?.ISQUAHAN == 1;
                /*                bool daDuyet = okc?.GQ_TINHTRANG == 1;*/
                bool daDuyet = lstKN.Any(x => x.GQ_TINHTRANG == 1);
                bool duyetChapNhan = lstKN.Any(x => x.GQ_ISCHAPNHAN == 1);
                bool coKhangCaoDungHan = lstKN.Any(x => x.ISQUAHAN == 0);
                bool tatCaKNDungHan = lstKN.All(x => x.ISQUAHAN == 0);
                /*                // donId là biến decimal truyền vào
                                var groups = dt.XLHC_SOTHAM_KHANGCAO
                                    .Where(x => x.DONID == donId)
                                    .GroupBy(x => x.SOQDBA)
                                    .ToList();
                                bool coKNQuaHanDuocDuyet = groups.Any(g => g.All(x => x.GQ_ISCHAPNHAN == 1));*/

                if (lstKhieuNai.Any() && lstKienNghi.Any() && lstKhangNghi.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KHIEUNAI_KIENNGHI_KHANGNGHI;
                    noiDungBase = "Do có khiếu nại, kiến nghị và kháng nghị phúc thẩm";
                }
                else if (lstKhieuNai.Any() && lstKienNghi.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KHIEUNAI_KIENNGHI;
                    noiDungBase = "Do có khiếu nại và kiến nghị phúc thẩm";
                }
                else if (lstKhieuNai.Any() && lstKhangNghi.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KHIEUNAI_KHANGNGHI;
                    noiDungBase = "Do có khiếu nại và kháng nghị phúc thẩm";
                }
                else if (lstKienNghi.Any() && lstKhangNghi.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KIENNGHI_KHANGNGHI;
                    noiDungBase = "Do có kiến nghị và kháng nghị phúc thẩm";
                }
                else if (lstKhieuNai.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KHIEUNAI;
                    noiDungBase = "Do có khiếu nại phúc thẩm";
                }
                else if (lstKienNghi.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KIENNGHI;
                    noiDungBase = "Do có kiến nghị phúc thẩm";
                }
                else if (lstKhangNghi.Any())
                {
                    lyDo = ENUM_TRUONGHOP_GIAONHAN.KHANGNGHI;
                    noiDungBase = "Do có kháng nghị phúc thẩm";
                }

                if (!string.IsNullOrEmpty(noiDungBase))
                {
                    if (coKhangCaoDungHan)
                    {
                        if (!tatCaKNDungHan)
                        {
                            if (daDuyet)
                            {
                                noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn đã duyệt)</span></b>";
                            }
                            else
                            {
                                noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn chưa duyệt)</span></b>";
                            }
                        }
                        else
                        {
                            noiDung = noiDungBase;
                        }
                        enableCheckBox = true;
                    }
                    else
                    {
                        if (daDuyet)
                        {
                            noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn đã duyệt)</span></b>";
                            if (duyetChapNhan)
                            {
                                enableCheckBox = true;
                            }
                            else
                            {
                                enableCheckBox = false;
                            }
                            /*                            if (coKNQuaHanDuocDuyet)
                                                        {
                            *//*                                noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn đã duyệt)</span></b>";*//*
                                                            enableCheckBox = true;
                                                        } else
                                                        {
                            *//*                                noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn chưa duyệt)</span></b>";*//*
                                                            enableCheckBox = coKNQuaHanDuocDuyet;
                                                        }*/
                            /*                            noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn đã duyệt)</span></b>";
                                                        enableCheckBox = true;*/
                        }
                        else
                        {
                            noiDung = $"{noiDungBase} <b><span style='color: red'>(KN quá hạn chưa duyệt)</span></b>";
                            enableCheckBox = false;
                        }
                    }
                }
            }
        }

        private void listChuyenAnPhucTham(object sender, DataGridItemEventArgs e)
        {
            var rv = (DataRowView)e.Item.DataItem;
            var lstNgaythuly = (Literal)e.Item.FindControl("lstNgaythuly");
            var lstNoiDung = (Literal)e.Item.FindControl("lstNoiDung");
            var hddLydo = (HiddenField)e.Item.FindControl("hddLydo");
            var chkChon = (CheckBox)e.Item.FindControl("chkChon");
            HiddenField hddTHGiaoNhan = (HiddenField)e.Item.FindControl("hddTHGiaoNhan");

            string strID = e.Item.Cells[0].Text, strNoiDung = "";
            decimal ID = Convert.ToDecimal(strID);
            var oTL = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).FirstOrDefault();
            if (oTL != null)
                lstNgaythuly.Text = oTL.NGAYTHULY?.ToString("dd/MM/yyyy");

            if (rdbTrangthai.SelectedValue == "0")
            {
                DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.FirstOrDefault(x => x.MA == "CVA");
                if (oDMQD != null)
                {
                    decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    var oQD = dt.XLHC_SOTHAM_QUYETDINH
                        .Where(x => x.DONID == ID && x.LOAIQDID == oDMQD.ID && x.TOAANID == IDToa)
                        .OrderByDescending(y => y.NGAYQD)
                        .FirstOrDefault();
                    if (oQD != null)
                    {
                        hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU;
                        lstNoiDung.Text = "Không thuộc thẩm quyền xét xử";
                        return;
                    }
                }

                // Gọi hàm xử lý kháng cáo/phúc thẩm
                var lstPT = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == ID && x.KETQUAPHUCTHAMID == 4).ToList();
                var okc = lstPT.OrderByDescending(y => y.TK_ISQUAHAN).FirstOrDefault();

                bool isQuaHan = okc?.TK_ISQUAHAN == 1;

                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.HUYQD_CHUYENHOSO; ;
                strNoiDung = "Huỷ QĐ và chuyển hồ sơ để xem xét, giải quyết lại";
                chkChon.Enabled = true;
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
            hddTHGiaoNhan.Value = strNoiDung;
            lstNoiDung.Text = "<b>- Lý do:</b> " + strNoiDung + "<br/>" + rv["v_NOIDUNG"];

            LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
            if (rdbTrangthai.SelectedValue == "1")
                lbtHuyChuyen.Visible = true;
            else
                lbtHuyChuyen.Visible = false;
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
                decimal DonID = 0;
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        DonID = Convert.ToDecimal(chkChon.ToolTip);
                        break;
                    }
                }
                HuyChuyen(DonID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal DonID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "HuyChuyen":
                        HuyChuyen(DonID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        //private void HuyChuyen(decimal DonID)
        //{
        //    // Án chưa được nhận mới cho phép hủy chuyển án.
        //    XLHC_CHUYEN_NHAN_AN_BL Bl = new XLHC_CHUYEN_NHAN_AN_BL();
        //    string Message_Ex = "Không được phép hủy chuyển án.";
        //    string Result = Bl.Check_NhanAn(DonID, Message_Ex);
        //    if (Result == "") // Án chưa nhận
        //    {
        //        XLHC_CHUYEN_NHAN_AN ObjChuyenNhan = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID).FirstOrDefault();
        //        if (ObjChuyenNhan != null)
        //        {
        //            dt.XLHC_CHUYEN_NHAN_AN.Remove(ObjChuyenNhan);
        //            dt.SaveChanges();
        //            dgList.CurrentPageIndex = 0;
        //            hddPageIndex.Value = "1";
        //            LoadGrid();
        //            lbthongbao.Text = "Hủy chuyển án thành công.";
        //        }
        //    }
        //    else
        //    {
        //        lbthongbao.Text = Result;
        //    }
        //}

        private void HuyChuyen(decimal DonID)
        {
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            // Án chưa được nhận mới cho phép hủy chuyển án.
            XLHC_CHUYEN_NHAN_AN_BL Bl = new XLHC_CHUYEN_NHAN_AN_BL();
            string Message_Ex = "Không được phép hủy chuyển án.";
            string Result = Bl.Check_NhanAn_V2(DonID, Message_Ex, TOAANID);
            if (Result == "") // Án chưa nhận
            {
                XLHC_CHUYEN_NHAN_AN ObjChuyenNhan = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID && x.TOACHUYENID == TOAANID)
                    .OrderByDescending(x => x.ID).FirstOrDefault();
                if (ObjChuyenNhan != null)
                {
                    dt.XLHC_CHUYEN_NHAN_AN.Remove(ObjChuyenNhan);
                    dt.SaveChanges();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    lbthongbao.Text = "Hủy chuyển án thành công.";
                }
            }
            else
            {
                lbthongbao.Text = Result;
            }
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
                    XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    int temp = 0;
                    if (oDon != null && oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                    {
                        XLHC_DON oDonST = dt.XLHC_DON.Where(x => x.MAVUVIEC == mavuviec && x.TOAANID != toaanST).FirstOrDefault();
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