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
namespace WEB.GSTP.QLAN.THA.CongVanTHA
{
    public partial class KQGiaiQuyet_Ds : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0, VuAnID=0, BiAnID;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                if (!IsPostBack)
                {
                    
                    LoadDrop();
                   
                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                        if (objBA != null)
                            VuAnID = (decimal)objBA.VUANID;
                        LoadGrid();
                        CheckQuyen();
                    }
                    else
                    {
                        pn.Visible = false;
                        lbthongbao.Text = "Bạn cần chọn bị án để xử lý!";
                    }
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;

            try
            {
                THA_CVDON_THULY obj = dt.THA_CVDON_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_CVDON_THULY>();
                if (obj == null)
                {
                    lttMsg.Text = "Chưa thụ lý công văn. Bạn hãy kiểm tra lại!";
                    //cmdSave.Visible = false;
                    cmdTimkiem.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Chưa thụ lý công văn. Bạn hãy kiểm tra lại!";
                //cmdSave.Visible = false;
                cmdTimkiem.Visible = false;
                IsOk = false;
            }
        }

        void LoadDrop()
        {
            dropLoaiLuaChon.Items.Clear();
            dropLoaiLuaChon.Items.Add(new ListItem("------------Tất cả----------", "2"));
            dropLoaiLuaChon.Items.Add(new ListItem("Chưa giải quyết", "0"));
            dropLoaiLuaChon.Items.Add(new ListItem("Đã giải quyết", "1"));
        }
        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal tinhtrang_gq = Convert.ToDecimal(dropLoaiLuaChon.SelectedValue);
            THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (objBA != null)
                VuAnID = (decimal)objBA.VUANID;
            THA_CVDON_KQGQ_BL objBL = new THA_CVDON_KQGQ_BL();
            DataTable tbl = objBL.GetAllPaging(VuAnID, BiAnID,tinhtrang_gq, pageindex, page_size);
           
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
                hddTotalPage.Value = all_page.ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                rpt.Visible = true;
                rpt.DataSource = tbl;
                rpt.DataBind();
                pnpaging_top.Visible = pnpaging_bottom.Visible = true;
            }
            else
            {
                rpt.Visible = false;
                pnpaging_top.Visible = pnpaging_bottom.Visible = false;
                //lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
                DataRowView rv = (DataRowView)e.Item.DataItem;

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.CAPNHAT);
              

                Decimal ThuLyCV_ID = Convert.ToDecimal(rv["ID"] + "");
                THA_CVDON_KQGQ oKQGQ = null;
                try
                {
                    oKQGQ = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == ThuLyCV_ID).FirstOrDefault();
                }
                catch (Exception ex) { }

                THA_CVDON_QD obj = null;
                try
                {
                    obj = dt.THA_CVDON_QD.Where(x => x.BIANID == BiAnID
                                                      && x.CVDONID == ThuLyCV_ID).FirstOrDefault();
                }
                catch (Exception ex) { }
                
                // Kiểm tra có 4.3 Quyết định chưa 
                if ( obj != null)
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                }
                else
                {   if (oKQGQ == null)
                        lbtXoa.Visible = false;
                    else
                        lbtXoa.Visible = true;
                }
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                HiddenField hddQuyetDinhID = (HiddenField)e.Item.FindControl("hddQuyetDinhID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                  
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;

                    if (Convert.ToDecimal(hddQuyetDinhID.Value.ToString()) > 0)
                    {
                        lblSua.Visible = false;
                    } else
                    {
                        lblSua.Visible = true;
                    }
                }
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Decimal ThuLyCV_ID = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "sua":
                    Response.Redirect("/QLAN/THA/CongVanTHA/KQGiaiQuyet.aspx?tID=" + ThuLyCV_ID);
                    break;
                case "Xoa":
                    //Kiểm tra xem có quyên sửa xóa không
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(ThuLyCV_ID);
                    break;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        #endregion
       
    

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        public void xoa(decimal CVid)
        {
            decimal bianID = 0;
            THA_CVDON_KQGQ oND = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == CVid).FirstOrDefault();
            if (oND != null)
            {
                bianID = oND.BIANID + "" == "" ? 0 : (decimal)oND.BIANID;
                Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                // Kiểm tra có 4.3 Quyết định chưa 
                THA_CVDON_QD obj = null;
                try
                {
                    obj = dt.THA_CVDON_QD.Where(x => x.BIANID == BiAnID
                                                      && x.CVDONID == CVid).FirstOrDefault();
                }
                catch (Exception ex) { }

                if (obj != null)
                {
                    lbthongbao.Text = "4.3 Quyết định đã ra. Không được xóa.";
                    return;
                }
                else
                {
                    dt.THA_CVDON_KQGQ.Remove(oND);
                    dt.SaveChanges();
                    lbthongbao.Text = "Xóa thành công!";
                }

                LoadGrid();
            }
            
        }
    }
}