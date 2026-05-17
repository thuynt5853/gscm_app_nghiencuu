<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="PhancongTP.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.PCTP.PhancongTP" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddCA_ID" runat="server" Value="0" />
     <asp:HiddenField ID="hddKetquaID" runat="server" Value="0" />
    <asp:HiddenField ID="hddLoaiToa" runat="server" Value="CAPHUYEN" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung" style="left:14px;" >
                <%--TPB3--%>
                <br />
                <asp:RadioButtonList ID="rdbTPb" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbTPb_SelectedIndexChanged">
                    <asp:ListItem Text="Thẩm phán tối cao &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" Value="0" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Thẩm phán bậc 3" Value="1"></asp:ListItem>
                </asp:RadioButtonList>
                <br />
                <%--end--%>
                <h4 class="tleboxchung">Phân công Thẩm phán giải quyết</h4>
                <div class="boder" style="padding: 10px;">

                    <%--TPB3--%>
                    <br />
                    <asp:RadioButtonList ID="rdbPc" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbPc_SelectedIndexChanged">
                        <asp:ListItem Text="Phân công ngẫu nhiên&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Phân công chỉ định" Value="1"></asp:ListItem>
                    </asp:RadioButtonList>
                    <br />
                    <%--end--%>

                    <table class="table1">
                        <tr>
                            <td style="width: 90px;">Tên tòa án</td>
                            <td colspan="3">
                                <asp:TextBox ID="txtToaan" runat="server" Enabled="false" CssClass="user" Width="300px"></asp:TextBox></td>
                             <td rowspan="6" style="vertical-align: top;width:250px;">                               
                                    <div style="height:170px;overflow:auto;">
                                        <asp:CheckBoxList ID="chkNguoinhap" runat="server" RepeatColumns="2" Width="98%" RepeatDirection="Vertical">
                                                    </asp:CheckBoxList>
                                   </div>
                            </td>
                            <td rowspan="6" style="vertical-align: top;">                               
                                    <div style="height:170px;overflow:auto;">
                                        <asp:Repeater ID="rptCanbo" runat="server">
                                            <HeaderTemplate>
                                                <table class="table2">
                                                    <tr class="header">
                                                        <td>TT</td>
                                                        <td>Thẩm phán</td>
                                                        <td>Lĩnh vực</td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="width: 15px;"><%# Container.ItemIndex + 1 %></td>
                                                    <td><%#Eval("Hoten")%> </td>
                                                    <td ><%#Eval("LINHVUC")%></td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                   </div>
                            </td>
                        </tr>
                        <tr>
                            <%--TPB3--%>
                            <td>Hình thức</td>
                            <td>
                               <asp:DropDownList ID="ddlHinhthuc" runat="server" Width="130px" CssClass="chosen-select"
                                   AutoPostBack="true" OnSelectedIndexChanged="dropHinhthuc_SelectedIndexChanged">
                                                    <asp:ListItem Value="0" Text="Đơn GDTT" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Hồ sơ Kháng nghị VKS"></asp:ListItem>                                                    
                                                </asp:DropDownList>
                            </td>
                             <%--end--%>
                            <td>Ngày phân công</td>
                            <td style="width: 130px;">
                                <asp:TextBox ID="txtNgayphancong" Enabled="false" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            </td>
                            <td style="width: 60px;"></td>
                            <td style="width: 120px;">
                              
                            </td>
                        </tr>
                       
                        <tr>
                            <td>Nhập đơn từ</td>
                            <td > <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                              </td>
                            <td>
                                Đến ngày
                                </td>
                            <td>
                                  <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <%--TPB3--%>
                        <tr>
                            <td><asp:Label ID="lblSothuly" Text="Số thụ lý" runat="server" Visible="false"></asp:Label></td>
                            <td > <asp:TextBox ID="txtSoThuLy" runat="server" CssClass="user" Width="120px" MaxLength="200" Visible="false"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                </td>
                            <td><asp:Label ID="lblNgayThuLy" Text="Ngày thụ lý" runat="server" Visible="false"></asp:Label></td>
                            <td>
                                  <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user" Width="100px" MaxLength="10" Visible="false"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                </td>
                        </tr>
                        <tr>
                            <td><asp:Label ID="lblSoBAQD" Text="Số BA/QĐ" runat="server" Visible="false"></asp:Label></td>
                            <td > <asp:TextBox ID="txtSoBAQD" runat="server" CssClass="user" Width="120px" MaxLength="200" Visible="false"></asp:TextBox>
                                </td>
                            <td><asp:Label ID="lblThamphan" Text="Thẩm phán" runat="server" Visible="false"></asp:Label></td>
                            <td><asp:DropDownList ID="ddlThamphan" runat="server" Width="120px" Visible="false">
                                    </asp:DropDownList></td>
                        </tr>
                         <%--end--%>
                         <tr>
                            <td>Loại án</td>
                            <td colspan="4">
                                 <asp:CheckBoxList ID="chkLoaiAn" runat="server" RepeatColumns="4"  RepeatDirection="Horizontal">
                                                    </asp:CheckBoxList>                                
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">  &nbsp;<asp:Label ID="lblThongbao" runat="server" ForeColor="Red"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">
                                <asp:Button ID="cmdTraCuu" runat="server" CssClass="buttoninput" Text="1. Tìm kiếm đơn chưa phân công" OnClick="cmdTraCuu_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="boxchung">
            <h4 class="tleboxchung">Danh sách đơn đã thụ lý và chưa phân công thẩm phán</h4>
            <div class="boder" style="padding: 20px; min-height: 200px;">
                <div style="width: 97%; padding: 5px; text-align: center; float: left;">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="2. Phân công ngẫu nhiên" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdPrint" Visible="false" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="cmdPrint_Click" />
                </div>               
                
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
                                        <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le" ItemStyle-CssClass="chan" >
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>                           
                                    <asp:TemplateColumn HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>      
                                     <asp:BoundColumn DataField="TL_SO" HeaderText="Số thụ lý" HeaderStyle-Width="45px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>   
                                    <asp:BoundColumn DataField="TL_NGAY" HeaderText="Ngày thụ lý" HeaderStyle-Width="65px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>   
                                       <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin người đứng đơn</HeaderTemplate>
                                        <ItemTemplate>
                                           <b><%#Eval("NGUOIGUI_HOTEN") %></b><br />  
                                          <%#Eval("Diachigui") %>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                     <%--<asp:BoundColumn DataField="BAQD" HeaderText="Số BA/QĐ" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>   
                                    <asp:BoundColumn DataField="BAQD_NGAYBA" HeaderText="Ngày BA/QĐ" HeaderStyle-Width="65px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>   

                                     <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center"  ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Tòa án xét xử</HeaderTemplate>
                                        <ItemTemplate>
                                              <%#Eval("TOAXX") %>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>--%>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin BA/QĐ đề nghị GĐT,TT</HeaderTemplate>
                                        <ItemTemplate>
                                             <b><%#Eval("BAQD") %></b> <i>Ngày: <b><%# GetDate(Eval("BAQD_NGAYBA")) %></b></i>
                                            &nbsp;<b><%#Eval("TOAXX_VietTat") %></b><br />
                                            <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": "<hr  style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_PT")+"<br/>") +
                                                        "<hr style='border-bottom: 0.5px dotted #808080;'>" +        
                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                                            <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": "<hr style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_ST") + "<br/>"):""%></i>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>

                                      <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                        <ItemTemplate>
                                        <%#Eval("TENTHAMPHAN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ghi chú</HeaderTemplate>
                                        <ItemTemplate>
                                        <%#Eval("GHICHU") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <%--Phân công chỉ định--%>
                             <asp:DataGrid ID="dgListC" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le" ItemStyle-CssClass="chan" >
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>                           
                                    <asp:TemplateColumn HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="55" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"> 
                                        <HeaderTemplate><asp:CheckBox ID="chkAllSelect" runat="server" onclick="checkAll(this);" Text="Chọn" /> </HeaderTemplate> 
                                        <ItemTemplate> <asp:CheckBox ID="chkSelect" onclick="Check_Click(this);EnableBTN(this);" runat="server" /> </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderText="Order Number" Visible="false">                
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtCheck" runat="server" Text='<%# Bind("ID") %>' Visible="false"></asp:TextBox>
                                        </ItemTemplate>                    
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="TL_SO" HeaderText="Số thụ lý" HeaderStyle-Width="45px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>   
                                    <asp:BoundColumn DataField="TL_NGAY" HeaderText="Ngày thụ lý" HeaderStyle-Width="65px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>   
                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin người đứng đơn</HeaderTemplate>
                                        <ItemTemplate>
                                           <b><%#Eval("NGUOIGUI_HOTEN") %></b><br />  
                                          <%#Eval("Diachigui") %>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                   
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin BA/QĐ đề nghị GĐT,TT</HeaderTemplate>
                                        <ItemTemplate>
                                             <b><%#Eval("BAQD") %></b> <i>Ngày: <b><%# GetDate(Eval("BAQD_NGAYBA")) %></b></i>
                                            &nbsp;<b><%#Eval("TOAXX_VietTat") %></b><br />
                                            <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": "<hr  style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_PT")+"<br/>") +
                                                        "<hr style='border-bottom: 0.5px dotted #808080;'>" +        
                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                                            <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": "<hr style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_ST") + "<br/>"):""%></i>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>

                                      <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                        <ItemTemplate>
                                        <%#Eval("TENTHAMPHAN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ghi chú</HeaderTemplate>
                                        <ItemTemplate>
                                        <%#Eval("GHICHU") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>

                            <div class="phantrang">
                                <div class="sobanghi" style="left:14px;">
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
                                        <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
            </div>


        </div>

    </div>
    <script type="text/javascript">
                                function popup_in() {                                  
                                    var hddCurrID = $("#<%= hddKetquaID.ClientID %>").val();
                                    var link = "/BaoCao/PCTP/ViewReport.aspx?cid=" + hddCurrID;
                                        var width = 1100;
                                        var height = 700;
                                        PopupReport(link, "Phân công thẩm phán giải quyết đơn", width, height);
                                }
                                function PopupReport(pageURL, title, w, h) {
                                   var left = (screen.width / 2) - (w / 2);
                                    var top = (screen.height / 2) - (h / 2);
                                    //OpenPopUpPage(pageURL, null, w, h);
                                    var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                                   return targetWin;
                               }
                            </script>
</asp:Content>
