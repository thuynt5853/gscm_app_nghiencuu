using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.THA;
using System.Globalization;
using System.Web.UI.WebControls;
using BL.GSTP.AHS;
using DevExpress.Utils.Extensions;
using DevExpress.CodeParser;
using DevExpress.PivotGrid.OLAP.SchemaEntities;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.THA;

namespace WEB.GSTP.QLAN.THA
{
    public partial class NhanUyThacTHA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0;
        decimal BiAnID = 0;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadDropLoai();
                    //Chọn trạng thái đã nhận sau khi nhận ủy thác THA
                    if (Session["trangthai"] != null)
                    {
                        dropLoaiLuaChon.SelectedIndex = 1;
                        Session.Remove("trangthai");
                    }
                    LoadGrid();
                    // CheckQuyen();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Button btnNhanUyThac = (Button)e.Item.FindControl("btnNhanUyThac");
                Button btnHuyNhan = (Button)e.Item.FindControl("btnHuyNhan");
                Button btnTraLaiBiAn = (Button)e.Item.FindControl("btnTraLaiBiAn");

                if (dropLoaiLuaChon.SelectedValue == "1")
                {
                    dgList.Columns[4].Visible = true;
                    dgList.Columns[5].Visible = true;
                    btnNhanUyThac.Visible = false;
                    //btnHuyNhan.Visible = true;
                    // kiểm tra ủy thác án đã được thụ lý chưa, nếu rồi ko cho phép hủy nhận
                    DataRowView rowView = (DataRowView)e.Item.DataItem;
                    int THA_TLid = (string.IsNullOrEmpty(rowView["ID"] + "")) ? 0 : Convert.ToInt16(rowView["ID"] + "");
                    THA_BIAN objBA = dt.THA_BIAN.Where(x => x.UYTHAC_DETAIL_ID == THA_TLid).FirstOrDefault() ?? new THA_BIAN();
                    THA_THULY objTL = dt.THA_THULY.Where(x => x.BIANID == objBA.ID && x.TRUONGHOPTHULY == 1).FirstOrDefault() ?? new THA_THULY();
                    if (objTL.ID != 0)
                    {
                        btnHuyNhan.Visible = false;
                    }
                    else
                    {
                        btnHuyNhan.Visible = true;
                    }
                    btnTraLaiBiAn.Visible = false;
                }

                else
                {
                    dgList.Columns[4].Visible = false;
                    dgList.Columns[5].Visible = false;
                    btnNhanUyThac.Visible = true;
                    btnTraLaiBiAn.Visible = true;
                    btnHuyNhan.Visible = false;
                }
            }

        }
        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdThemmoi.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdThemmoi.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdThemmoi.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdThemmoi.Visible = false;
                    IsOk = false;
                }
            }
        }
        void LoadDropLoai()
        {
            dropLoaiLuaChon.Items.Clear();
            dropLoaiLuaChon.Items.Add(new ListItem("Chưa nhận", "0"));
            dropLoaiLuaChon.Items.Add(new ListItem("Đã nhận", "1"));
        }
        protected void dropLoaiLuaChon_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";

            LoadGrid();
        }
        //public void LoadGrid()
        //{
        //    Decimal CurrToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
        //    BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
        //    //decimal BiAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
        //    THA_UYTHAC_DETAIL_BL objBL = new THA_UYTHAC_DETAIL_BL();
        //    int Trangthai = Convert.ToInt16(dropLoaiLuaChon.SelectedValue);
        //    DataTable tbl = objBL.GetAllNhanUyThacByToaAn(CurrToaAnID, Trangthai );
        //    if (tbl != null)
        //    {
        //        //rpt.DataSource = tbl;
        //        //rpt.DataBind();
        //    }
        //}
        public void LoadGrid()
        {
            try
            {
                lbthongbao.Text = "";
                Decimal CurrToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                //decimal BiAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                THA_UYTHAC_DETAIL_BL objBL = new THA_UYTHAC_DETAIL_BL();
                int Trangthai = Convert.ToInt32(dropLoaiLuaChon.SelectedValue);
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
                Decimal HddToaAnUyThacID = 0;
                if (!hddToaAnUyThacID.Value.Equals(""))
                {
                    HddToaAnUyThacID = Decimal.Parse(hddToaAnUyThacID.Value);
                }
                if (txtToaAnUyThac.Text.Trim().Equals(""))
                {
                    HddToaAnUyThacID = 0;
                }

                DataTable oDT = objBL.GetAllNhanUyThacByToaAn(CurrToaAnID, Trangthai, txtTenBiAn.Text.Trim(), txtTenVuAn.Text.Trim(), txtNgayUyThac.Text.Trim(), HddToaAnUyThacID,
                        txtSoQD.Text.Trim(), txtNgayQD.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), pageindex, page_size);
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                    #region "Xác định số lượng trang"
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
                dgList.DataSource = oDT;
                dgList.DataBind();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }

        }
        //protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        DataRowView rv = (DataRowView)e.Item.DataItem;
        //        Decimal IDVuAnHeThong = Convert.ToDecimal(rv["IDVuAnHeThong"] + "");

        //        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
        //        Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

        //        LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
        //        Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
        //        if (IDVuAnHeThong > 0)
        //            lblSua.Visible = lbtXoa.Visible = false;
        //        else
        //            lblSua.Visible = lbtXoa.Visible = true;
        //    }
        //}

        //protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        //{
        //    switch (e.CommandName)
        //    {
        //        case "sua":
        //            Response.Redirect("/QLAN/THA/NhanUyThacTHA_Edit.aspx?uID=" + Convert.ToDecimal(e.CommandArgument.ToString()));
        //            break;
        //    }
        //}

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        //protected void btnSuaOnClick(object source, EventArgs e)
        //{
        //    LinkButton btn = (LinkButton)source;
        //    string commandArgument = btn.CommandArgument;
        //    if (commandArgument != null)
        //    {
        //        Response.Redirect("/QLAN/THA/NhanUyThacTHA_Edit.aspx?uID=" + Convert.ToDecimal(commandArgument));
        //    }
        //}
        protected void btnNhanUyThacOnClick(object source, EventArgs e)
        {
            Button btn = (Button)source;
            string commandArgument = btn.CommandArgument;
            if (commandArgument != null)
            {
                Response.Redirect("/QLAN/THA/NhanUyThacTHA_Edit.aspx?uID=" + Convert.ToDecimal(commandArgument));
            }
        }
        protected void btnHuyNhanOnClick(object source, EventArgs e)
        {
            try
            {
                Button btn = (Button)source;
                string commandArgument = btn.CommandArgument;
                if (commandArgument != null)
                {
                    decimal DetailUyThacID = Convert.ToDecimal(commandArgument);
                    THA_UYTHAC_DETAIL oTT_UYTHAC = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == DetailUyThacID).FirstOrDefault();
                    oTT_UYTHAC.TRANGTHAI = 0;
                    oTT_UYTHAC.NGAYNHANUYTHAC = null;
                    oTT_UYTHAC.NGUOIKY = null;
                    //xóa THA_BIAN và THA_VUAN mới thêm khi nhận án dựa vào DetailUyThacID khi bam huy nhan
                    THA_BIAN objBiAn = dt.THA_BIAN.Where(x => x.UYTHAC_DETAIL_ID == DetailUyThacID).FirstOrDefault();
                    THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == objBiAn.VUANID).FirstOrDefault();
                    List<THA_SOTHAM_BANAN_BICAO> asbbs = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_BICAO>($"BICAOID = {objBiAn.ID} AND VUANID = {objVuAn.ID}");
                    if (asbbs != null && asbbs.Count > 0)
                    {
                        foreach (THA_SOTHAM_BANAN_BICAO asbb in asbbs)
                        {
                            DataExtensions.Delete<THA_SOTHAM_BANAN_BICAO>(asbb);
                        }
                    }
                    List<THA_SOTHAM_BANAN_DIEU_TONGHOP> asbdts = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_DIEU_TONGHOP>($"BICANID = {objBiAn.ID} AND VUANID = {objVuAn.ID}");
                    if (asbdts != null && asbdts.Count > 0)
                    {
                        foreach (THA_SOTHAM_BANAN_DIEU_TONGHOP asbdt in asbdts)
                        {
                            DataExtensions.Delete<THA_SOTHAM_BANAN_DIEU_TONGHOP>(asbdt);
                        }
                    }
                    List<THA_SOTHAM_BANAN_DIEU_CHITIET> asbdcs = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_DIEU_CHITIET>($"BICANID = {objBiAn.ID} AND VUANID = {objVuAn.ID}");
                    if (asbdcs != null && asbdcs.Count > 0)
                    {
                        foreach (THA_SOTHAM_BANAN_DIEU_CHITIET asbdc in asbdcs)
                        {
                            DataExtensions.Delete<THA_SOTHAM_BANAN_DIEU_CHITIET>(asbdc);
                        }
                    }
                    List<THA_TONGHOPHINHPHAT> ats = DataExtensions.GetAllWithClause<THA_TONGHOPHINHPHAT>($"VUANID = {objVuAn.ID} AND BICAOID = {objBiAn.ID}");
                    if (ats != null && ats.Count > 0)
                    {
                        foreach (THA_TONGHOPHINHPHAT at in ats)
                        {
                            DataExtensions.Delete<THA_TONGHOPHINHPHAT>(at);
                        }
                    }
                    List<THA_PHUCTHAM_BANAN_BICAO> apbbs = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_BICAO>($"VUANID = {objVuAn.ID} AND BICAOID = {objBiAn.ID}");
                    if (apbbs != null && apbbs.Count > 0)
                    {
                        foreach (THA_PHUCTHAM_BANAN_BICAO apbb in apbbs)
                        {
                            DataExtensions.Delete<THA_PHUCTHAM_BANAN_BICAO>(apbb);
                        }
                    }
                    List<THA_PHUCTHAM_BANAN_DIEU_CT> apbdcs = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"VUANID = {objVuAn.ID} AND BICANID = {objBiAn.ID}");
                    if (apbdcs != null && apbdcs.Count > 0)
                    {
                        foreach (THA_PHUCTHAM_BANAN_DIEU_CT apbdc in apbdcs)
                        { 
                            DataExtensions.Delete<THA_PHUCTHAM_BANAN_DIEU_CT>(apbdc);
                        }
                    }
                    List<THA_SOTHAM_CAOTRANG_DIEULUAT> tscds = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == objBiAn.ID && x.VUANID == objVuAn.ID).ToList();
                    foreach (THA_SOTHAM_CAOTRANG_DIEULUAT tscd in tscds)
                    {
                        dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Remove(tscd);
                    }
                    if (objVuAn != null && objBiAn != null)
                    {
                        dt.THA_BIAN.Remove(objBiAn);
                        dt.THA_VUAN.Remove(objVuAn);
                    }
                    decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    oNSD.IDTHA = null;//luu thong tin id bi an de ghim
                    dt.SaveChanges();
                    Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
                    LoadGrid();
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }


        }
        protected void btnNhanUyThac_Click(object source, EventArgs e)
        {
            Button btn = (Button)source;
            string commandArgument = btn.CommandArgument;
            if (commandArgument != null)
            {
                //Response.Redirect("/QLAN/THA/NhanUyThacTHA_Edit.aspx?uID=" + Convert.ToDecimal(commandArgument));
            }
        }

        protected void btnTraLaiBiAnOnClick(object source, EventArgs e)
        {
            try
            {
                Button btn = (Button)source;
                string commandArgument = btn.CommandArgument;
                if (commandArgument != null)
                {
                    string username = Convert.ToString(Session[ENUM_SESSION.SESSION_USERNAME]);
                    decimal DetailUyThacID = Convert.ToDecimal(commandArgument);
                    THA_UYTHAC_DETAIL oTT_UYTHAC = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == DetailUyThacID).FirstOrDefault();
                    oTT_UYTHAC.TRANGTHAI = 3;
                    oTT_UYTHAC.NGAYTRALAI = DateTime.Now;
                    oTT_UYTHAC.NGUOITRALAI = username;

                    decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    oNSD.IDTHA = null;//luu thong tin id bi an de ghim
                    dt.SaveChanges();
                    Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
                    LoadGrid();
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }


        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            // Response.Redirect("/QLAN/THA/HoSo/ThongTinVA.aspx");
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            //dropLoaiLuaChon.SelectedIndex = 0;
            hddToaAnUyThacID.Value = "";
            txtToaAnUyThac.Text = "";
            txtTenBiAn.Text = "";
            txtTenBiAn.Text = "";
            txtTenVuAn.Text = "";
            txtSoQD.Text = "";
            txtNgayQD.Text = "";
            txtNgayUyThac.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                // dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        #endregion

    }
}