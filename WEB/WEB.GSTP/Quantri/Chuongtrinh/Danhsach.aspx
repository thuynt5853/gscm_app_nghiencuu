<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Quantri.Chuongtrinh.Danhsach" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<div class="box">
   
    <div class="box_nd">
        <div class="truong">
            <table class="table1">
                
                <tr>
                    <td style="width: 120px;">
                        Mã chương trình<asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label> 
                   
                    </td>
                    <td>
                        <asp:TextBox ID="txtMaChuongTrinh" runat="server" CssClass="user" Width="150px" MaxLength="250" 
                            ToolTip="Nhập mã chương trình" />
                      
                    </td>
                </tr>
                <tr>
                    <td>
                       Tên chương trình<asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label> 
                   
                    </td>
                    <td>
                        <asp:TextBox ID="txtTenChuongTrinh" runat="server" Width="99%" CssClass="user" MaxLength="500"
                            ToolTip="Nhập tên chương trình" />
                      
                    </td>
                </tr>               
                <tr>
                    <td>
                       Sử dụng
                    </td>
                    <td>
                          <asp:DropDownList CssClass="user" ID="ddlLoai" Width="150px" runat="server" >                              
                              <asp:ListItem Value="1"  Text="Sử dụng trong hệ thống" Selected="True"></asp:ListItem>
                              <asp:ListItem Value="0"  Text="Sử dụng trong phần mềm khác"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        Ảnh minh họa (đường dẫn ~/UI/img/)
                    </td>
                    <td>
                        <asp:TextBox ID="txtURL" runat="server" Width="99%" CssClass="user" MaxLength="250" />
                         <img runat="server" id="imageSRC" style="max-width:110px;max-height:110px;" src="imageIDtagName" />
                        <%-- <asp:HiddenField ID="hddFilePath" runat="server" />
                                <cc1:AsyncFileUpload  ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
             ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF"  />    
                                 <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                       
                    --%></td>
                </tr>
                <tr>
                    <td>
                        <b>Thứ tự</b>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="user" ID="dropThutu" Width="50px" runat="server" ToolTip="Lựa chọn thứ tự cho chương trình">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="bt" style="margin-left: 150px;">
              <asp:button id="cmdUpdate" runat="server" cssclass="buttoninput" text="Lưu"  onclick="btnCapNhat_Click"  />
             
                <asp:button id="cmdLammoi" runat="server" cssclass="buttoninput" text="Làm mới" onclick="btnLammoi_Click" />

               <asp:button id="cmdDel" runat="server" cssclass="buttoninput" text="Hủy Lưu" onclick="btnHuyCapNhat_Click"  />
                   
        </div>
        <div>
            <asp:Label ID="lblmgs" ForeColor="Red" runat="server"></asp:Label>
            <asp:HiddenField ID="hddchuongtrinhID" runat="server" Value="0" />
        </div>
        <div class="phantrang">
            <div class="sobanghi">
                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
            </div>
            <div class="sotrang">
                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                    OnClick="lbTBack_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                    OnClick="lbTNext_Click"></asp:LinkButton>
            </div>
        </div>
        <div>
            <asp:DataGrid ID="dgrDanhMucCT" runat="server" AutoGenerateColumns="False" CellPadding="4"
                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgrDanhMucCT_ItemCommand">
                <Columns>
                    <asp:BoundColumn  DataField="ID" Visible="false"></asp:BoundColumn>
                    <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-Width="30px">
                        <HeaderTemplate>
                            Thứ tự
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("THUTU")%>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:TemplateColumn>                     
                    <asp:TemplateColumn ItemStyle-Width="60px" HeaderStyle-Width="60px">
                        <HeaderTemplate>
                            Mã chương trình
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("MA")%>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Width="60px"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-Width="120px">
                        <HeaderTemplate>
                            Tên chương trình
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("TEN") %>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                    </asp:TemplateColumn>
                 
                    <asp:TemplateColumn ItemStyle-Width="30px" HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Loại
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# (Eval("LOAI")+"") =="1" ? "Sử dụng trong hệ thống" : "Sử dụng trong phần mềm khác"%>
                        </ItemTemplate>
                        <HeaderStyle Width="30px"></HeaderStyle>
                        <ItemStyle Width="30px"></ItemStyle>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Thao tác
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="sua"  ForeColor="#0e7eee"
                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"  ForeColor="#0e7eee"
                                CommandName="xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa chương trình này?');"></asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Width="50px"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:TemplateColumn>
                </Columns>
                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false">
                </PagerStyle>
                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            </asp:DataGrid>
        </div>
        <div class="phantrang">
            <div class="sobanghi">
                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
            </div>
            <div class="sotrang">
                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                    OnClick="lbTBack_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                    OnClick="lbTNext_Click"></asp:LinkButton>
            </div>
        </div>
    </div>
</div>

</asp:Content>
