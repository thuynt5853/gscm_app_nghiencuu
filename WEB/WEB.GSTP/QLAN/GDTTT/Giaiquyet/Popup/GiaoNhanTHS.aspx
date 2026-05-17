<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GiaoNhanTHS.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup.GiaoNhanTHS" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sửa đổi thông tin đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }
    </style>
    <form id="form1" runat="server">
     
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                            <ContentTemplate>
                                                 <div class="boxchung">
                  
                <table class="table1">                   
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                             <asp:Button ID="cmdLuu" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu" OnClick="cmdLuu_Click" />
                             <asp:Button ID="cmdLuuAndNext" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu & Chuyển trang" OnClick="cmdLuuAndNext_Click" />
                             <asp:Button ID="cmdPrint" runat="server" CssClass="btnBuoc  bg_do" Text="In Danh sách" OnClick="cmdPrint_Click" />
                            <asp:Button ID="Button1" runat="server" CssClass="btnBuoc  bg_do" Text="Đóng" OnClientClick="window.close();" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div style="width:100%;margin-bottom:100px;">
                               <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10" ></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan"  OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                     <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                     <asp:BoundColumn DataField="ths_ID" Visible="false"></asp:BoundColumn>
                                    
                                    <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT") %></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="65px"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Số & Ngày<br />
                                            CV chuyển
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <b><%#Eval("CD_SOCV") %></b>
                                            <br />
                                            <%# Eval("CD_NGAYCV") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="65px"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày<br />
                                            thụ lý</HeaderTemplate>
                                        <ItemTemplate><asp:Literal ID="lttThuLy" runat="server"></asp:Literal>
                                            <span style="float: left; width: 100%;"><%#Eval("arrTTTL") %></span>
                                           
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-VerticalAlign="Top" HeaderStyle-Width="140px">
                                        <HeaderTemplate>Người đề nghị, kiến nghị, thông báo</HeaderTemplate>
                                        <ItemTemplate>
                                            <b><%#Eval("DONGKHIEUNAI") %></b>
                                            <%# (Eval("arrCongvan")+"")=="" ? "":"(" + Eval("arrCongvan") + ")" %>
                                             <br /><span style='font-size:12px;'>Ngày VP xử lý: <%#Eval("NgayTaoStr") %></span>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Justify"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                        <HeaderTemplate>Địa chỉ</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("Diachigui") %>
                                            <%-- <br />                                          
                                            <i><%# Convert.ToInt32(Eval("LOAIDON"))==2 ? "Ngày công văn":"Ngày trên đơn" %>  
                                            </i>: <%# GetDate(Eval("NGAYGHITRENDON")) %>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin BA/QĐ đề nghị GĐT,TT</HeaderTemplate>
                                        <ItemTemplate>
                                            <b><%#Eval("BAQD_SO") %></b><br />
                                            <%# GetDate(Eval("BAQD_NGAYBA")) %><br />
                                            <%#Eval("TOAXX_VietTat") %>
                                            <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": "<hr  style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_PT")+"<br/>") +
                                                        "<hr style='border-bottom: 0.5px dotted #808080;'>" +        
                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                                            <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": "<hr style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_ST") + "<br/>"):""%></i>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số đơn</HeaderTemplate>
                                        <ItemTemplate>
                                                <asp:HiddenField ID="hddArrDonTrung" runat="server" Value='<%#Eval("ARRDONTRUNG") %>' />
                                             <asp:HiddenField ID="hddDCID" runat="server" Value='<%#Eval("DCID") %>' />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%#Eval("SODON") %>'
                                                CommandName="SoDonTrung" CommandArgument='<%#Eval("ARRDONTRUNG") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                        <HeaderTemplate>Ghi chú</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("GHICHU") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người Giao</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlNguoiGiao"  AutoPostBack="True" OnSelectedIndexChanged="ddlNguoiGiao_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px"></asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
 
                                    <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người Nhận</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlNguoiNhan"  AutoPostBack="True" OnSelectedIndexChanged="ddlNguoiNhan_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px"></asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày nhận THS</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNGAYNHANTHS" runat="server" Text='<%# Eval("NGAYNHANTHS") %>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtNGAYNHANTHS_CalendarExtender" runat="server" TargetControlID="txtNGAYNHANTHS" Format="dd/MM/yyyy" />
                                            <cc1:MaskedEditExtender ID="txtNGAYNHANTHS_MaskedEditExtender3" runat="server" TargetControlID="txtNGAYNHANTHS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn> 
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ghi Chú</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtGhiChu" runat="server" TextMode="MultiLine" Height="60" Text='<%# Eval("GHICHUTHS") %>' CssClass="user" Width="120px" MaxLength="10000"></asp:TextBox>
                                           <%-- <asp:LinkButton ID="btnDel" OnLoad="btnDel_Load" CommandArgument='<%# Eval("ID") %>' CommandName="Delete" runat="server">delete</asp:LinkButton>--%>
                                          <asp:ImageButton ID="IB_tn" runat="server" ImageUrl="~/UI/img/delete.png" Width="17px"
                                                OnClick="IB_tn_Click"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ths_ID") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateColumn> 
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                                </div>
                        </td>
                    </tr>
                </table>
           
        </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>

                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                            <ProgressTemplate>
                                                <div class="processmodal">
                                                    <div class="processcenter">
                                                        <img src="/UI/img/process.gif" />
                                                    </div>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
    
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
     <script type="text/javascript">
        function pageLoad(sender, args) {           
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
    </script>
</html>
